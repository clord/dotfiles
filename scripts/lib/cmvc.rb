require 'lib/ioopen'
require 'lib/util'
module Cmvc
   include IOOpen
   CMVC_DIR = "/usr/lpp/cmvc/bin"

   class CmvcError
      attr_accessor :command, :status, :message, :stderr
      def initialize message, command = nil, status = nil, stderr = nil
         @command = command
         @status = status
         @message = message
         @stderr = stderr
      end
      def to_hash
         { :command => @command, :status => @status, :stderr => @stderr }
      end
   end

   # Prefix a string with a list of tags, in the CMVC manner
   def self.prefix pfxs, str
      return str unless pfxs && pfxs.length > 0
      pfxs.join(':') + ": " + str
   end


   # Given a string containing lines and a list of keys, converts CMVC's raw format into an array of Hashes.
   # if you want to ignore a line, pass a key called :ignore for that index.
   def processraw str, keys
      str.readlines.collect do |l|
         spltline = l.chomp.split "|"
         returning Hash.new do |h|
            keys.each_index do |i|
               h[keys[i]] = spltline[i] unless keys[i] == :ignore
               end
         end
      end
   end

   # Wraps the command that produces the list of tracks.
   # TODO: Turn this into a CmvcCommand
   def gather_tracks states, release
      report_keys = [:release, :name, :ignore, :state, :ignore,
                     :date, :user, :user_name, :ignore, :ignore,
                     :ignore, :prefix, :abstract]
      statestr = states.collect { |s| "'#{s}'" }.join(', ')
      cmd = "#{CMVC_DIR}/Report -raw -view trackView -where \"releasename in '#{release}' and state in (#{statestr})\""
      erro = ""
      STDERR.puts cmd
      o = o_open(cmd) { |o,e| o = processraw(o, report_keys); erro = e.read; o }
      raise CmvcError.new("Failed to gather tracks", cmd, $?, erro) unless $?.success?
      return o
   end

   # Parameterized release extract. If a block is given, the block will be invoked every few seconds,
   # allowing you to update status reports and publish details.
   def release_extract_blk args
      cmvc_release = args[:release]
      comp = args[:component]
      become = args[:become]
      test_file = args[:check]
      dest_dir = args[:to]
      command = "#{CMVC_DIR}/Release -extract #{cmvc_release} -nokeys -node direct -root #{dest_dir}"
      command += " -component #{comp}" unless comp.nil?
      command += " -become #{become}" unless become.nil?
      STDERR.puts command
      if defined? yield
         pid = fork { exec command }
         while Process.waitpid(pid, Process::WNOHANG).nil? do
            sleep 2.5
            yield
         end
         yield
      else
         system command
      end
      raise CmvcError.new("Failed to extract #{cmvc_release}", command, $?, "") unless $?.success?
      # This is a very primitive sanity check mechanism that just verifies that the extract worked,
      # even if the process returned zero.
      raise CmvcError.new("Sanity check failed: #{test_file} does not exist") if !test_file.nil? && !(dest_dir + test_file).exist?
   end

   def release_extract args
      release_extract_blk(args) { driver.write_progress }
   end


   # Wraps up a cmvc command
   class Command
      attr_accessor :tool, :parameters

      # will use the parms hash to create a CMVC command to open a defect
      def initialize(tool, parms)
         @tool = tool
         raise "abstract is too long" if parms[:abstract] && parms[:abstract].length > 63
         @parameters = {}
         @parameters.update defaults
         parms.each { |k,v| @parameters[k.to_s.to_sym] = v }
      end


      # Generate a cmvc command line from nested hashes
      def parameters_to_cmvc_arg(parm=@parameters)
         cmd = ""
         parm.keys.each do |key|
            case parm[key].class.to_s
            when "Hash"
               cmd += " -#{key}"
               cmd += parameters_to_cmvc_arg(parm[key])
            when "FalseClass"
               # Do nothing
            when "TrueClass"
               cmd += " -#{key}"
            else
               cmd += " -#{key}"
               value = parm[key].to_s
               value = '"' + value + '"' if value =~ /\s/
               cmd += " " + value
            end
         end
         cmd
      end

      def to_s
         CMVC_DIR + "/" + @tool.to_s.gsub(/\b\w/){$&.upcase} + parameters_to_cmvc_arg
      end

      def exec
         puts "% " + to_s
         system to_s
         raise "Failed to execute #{to_s}" unless $?.success?
      end

      # Exec, but captures output as an array of lines
      def exec_read
         lines = []
         puts "% " + to_s
         IO.popen(to_s, mode="r") do |cmdout|
            lines = cmdout.readlines
         end
         raise CmvcError.new("Failed to exec '#{to_s}'") unless $?.success?
         return lines
      end

      def exec_open
         # executes the command, and parse out the result
         #
         #the stdout/stderr return looks like this:
         #new defect was opened successfully.
         #The new defect number is 368193.
         lines = exec_read
         return $2 if lines[1] =~ /^ *The new (defect|feature) number is ([-0-9a-z\.]+)\. *$/
         raise CmvcError.new("May have failed to open defect: could not parse '#{lines[1]}'")
      end



      def defaults
         case @tool
         when :defect
            case @command
            when :open
               return { prefix: "d", symptom: "ot" }
            end
         end
         return {}
      end
   end

   # Provides operations that depend on a defect or feature
   # With this, we can write:
   # Context.open(:defect, true, {severity: 3}).assign("...").accept("...").create_track("...")
   # and the pipeline will stall if anything fails.
   class Context
      attr_accessor :name, :exec_mode, :tool, :actions
      def initialize(name, tool=:defect, exec_mode=:dryrun)
         @name = name || "<#{tool}>"
         @exec_mode = exec_mode
         @tool = tool
         @actions = []
      end
      def self.open tool, parms, exec_mode=:dryrun
         must_contain parms, [:release, :abstract, :severity, :product, :component]
         Context.new(Command.new(tool, :open => parms).exec_open, tool, exec_mode)
      end
      def accept(remarks)
         @actions << {
            command: Command.new(@tool, accept: @name, remarks: remarks),
            thunk: proc { |c| c.exec }
         }
         return self
      end
      def view(view, where, &handler)
         @actions << {
            command: Command.new(:report, view: view, where: where, raw: true),
            thunk: proc { |c| c.exec_read.map { |i| i.split '|' } },
            safe: true,
            handler: handler
         }
         return self
      end
      def level_view(action, where, &handler)
         @actions << {
            command: Command.new(:level, view: action, where: where, raw: true),
            thunk: proc { |c| c.exec_read.map { |i| i.split '|' } },
            safe: true,
            handler: handler
         }
         return self
      end
      def release_view(action, where, &handler)
         @actions << {
            command: Command.new(:release, view: action, where: where, raw: true),
            thunk: proc { |c| c.exec_read.map { |i| i.split '|' } },
            safe: true,
            handler: handler
         }
         return self
      end
      def clean_up_map map
         {
            id: map[0].to_i,
            release: map[1],
            unknown1: map[2],
            component: map[3],
            version: map[4],
            path1: map[5],
            path2: map[6],
            unknown2: map[7],
            mode: map[8],
            type: map[9].to_sym,
            unknown3: map[10]
         }
      end
      private :clean_up_map
      def release_map release, &handler
         @actions << {
            command: Command.new(:release, map: release),
            thunk: proc { |c| c.exec_read.map { |i| clean_up_map(i.split('|')) } },
            safe: true,
            handler: handler
         }
         return self
      end
      def level_map release, &handler
         @actions << {
            command: Command.new(:level, map: release),
            thunk: proc { |c| c.exec_read.map { |i| clean_up_map(i.split('|')) } },
            safe: true,
            handler: handler
         }
         return self
      end
      def last_levels release, n, &handler
         releases = [*release].map { |a| "'#{a}'" }.join(", ")
         view 'LevelView', "releaseName in (#{releases}) and state = 'complete' order by commitDate desc fetch first #{n} rows only", &handler
      end
      def change_view release, &handler
         releases = [*release].map { |a| "'#{a}'" }.join(", ")
         view 'ChangeView', "releaseName in (#{releases}) and defectName='#{@name}'", &handler
      end
      def track_view release, &handler
         releases = [*release].map { |a| "'#{a}'" }.join(", ")
         view 'TrackView', "releaseName in (#{releases}) and defectName='#{@name}'", &handler
      end
      def fix_view release, &handler
         releases = [*release].map { |a| "'#{a}'" }.join(", ")
         view 'fixView', "releaseName in (#{releases}) and defectName='#{@name}'", &handler
      end
      def complete_fix component, release
         @actions << {
            command: Command.new(:fix, complete: {@tool => @name}, component: component, release: release),
            thunk: proc { |c| c.exec }
         }
         return self
      end
      def assign_fix user, component, release
         @actions << {
            command: Command.new(:fix, assign: {:to => user, @tool => @name}, component: component, release: release),
            thunk: proc { |c| c.exec }
         }
         return self
      end
      def activate_fix component, release
         @actions << {
            command: Command.new(:fix, activate: {@tool => @name}, component: component, release: release),
            thunk: proc { |c| c.exec }
         }
         return self
      end
      def assign(to)
         @actions << {
            command: Command.new(@tool, assign: @name, owner: to),
            thunk: proc { |c| c.exec }
         }
         return self
      end
      def track_integrate for_release
         @actions << {
            command: Command.new(:track, integrate: {@tool => @name}, release: for_release),
            thunk: proc {|c| c.exec }
         }
         return self
      end
      def track_fix for_release
         @actions << {
            command: Command.new(:track, fix: {@tool => @name}, release: for_release),
            thunk: proc {|c| c.exec }
         }
         return self
      end
      def create_track(for_release)
         raise "invalid tool #{@tool}" unless @tool == :defect || @tool == :feature
         @actions << {
            command: Command.new(:track, create: {@tool => @name}, release: for_release),
            thunk: proc { |c| c.exec }
         }
         return self
      end
      def create_tracks(releases)
         releases.each { |r| create_track(r) }
         return self
      end
      def approve_track(release, become)
         raise "invalid tool #{@tool}" unless @tool == :defect || @tool == :feature
         @actions << {
            command: Command.new(:approval, accept: {@tool => @name}, become: become, release: release),
            thunk: proc { |c| c.exec }
         }
         return self
      end
      def exec &a
         @actions.each do |action|
            if @exec_mode == :makeitso || action[:safe]
               r = action[:thunk].call(action[:command])
               action[:handler].call(r) if action[:handler]
            else
               puts "## #{action[:command]}"
            end
         end
         # Clear the list of actions so we can do it again
         @actions = []
      end
   end

end
