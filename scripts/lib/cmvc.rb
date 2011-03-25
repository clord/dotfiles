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

   def login
      system "ibmlogin"
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
      command = "Release -extract #{cmvc_release} -nokeys -node direct -root #{dest_dir}"
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
      attr_accessor :tool, :command, :exec_mode, :parameters

      # will use the parms hash to create a CMVC command to open a defect
      def initialize(tool, command, exec_mode=:dryrun, parms)
         @tool = tool
         @exec_mode = exec_mode
         @command = command
         raise "abstract is too long" if parms[:abstract] && parms[:abstract].length > 63
         @parameters = {}
         @parameters.update defaults
         @parameters.update parms
      end


      # Generate a cmvc command line from nested hashes
      def parameters_to_cmvc_arg(parm=@parameters)
         cmd = ""
         parm.keys.each do |key|
            cmd += " -#{key.to_s}"
            case parm[key].class.to_s
            when "Hash"
               cmd += parameters_to_cmvc_arg(parm[key])
            else
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
         return unless @exec_mode == :makeitso
         system to_s
      end

      def exec_open
         # executes the command, and parse out the result
         #
         #the stdout/stderr return looks like this:
         #new defect was opened successfully.
         #The new defect number is 368193.
         lines = []
         puts "% " + to_s
         return unless @exec_mode == :makeitso
         IO.popen(to_s, mode="r") do |cmdout|
            lines = cmdout.readlines
         end
         if $?.success? && lines[1] =~ /^ *The new (defect|feature) number is ([-0-9a-z\.]+)\. *$/
            return $2
         end
         raise CmvcError.new("May have failed to open defect: could not parse '#{lines[1]}'")
      end



      def defaults
         case @tool
         when :defect
            case @command
            when :open
               return { prefix: "d", symptom: "ot", severity: "3" }
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
      attr_accessor :name, :exec_mode, :tool
      def initialize(name, tool=:defect, exec_mode=:dryrun)
         @name = name || "<#{tool}>"
         @exec_mode = exec_mode
         @tool = tool
      end
      def self.open tool, parms, exec_mode=:dryrun
         must_contain parms, [:release, :abstract, :severity, :product, :component]
         Context.new(Command.new(tool, :open, exec_mode, :open => parms).exec_open, tool, exec_mode)
      end
      def accept(remarks)
         Command.new(@tool, :accept, @exec_mode, {:accept => @name, :remarks => remarks}).exec
         return self
      end
      def assign(to)
         Command.new(@tool, :assign, @exec_mode, {:assign => @name, :owner => to}).exec
         return self
      end
      def create_track(for_release)
         raise "invalid tool #{@tool}" unless @tool == :defect || @tool == :feature
         Command.new(:track, :create, @exec_mode, {:"create -#{@tool}" => @name, :release => for_release }).exec
         return self
      end
      def create_tracks(releases)
         releases.each { |r| create_track(r) }
         return self
      end
      def approve_track(release, become)
         raise "invalid tool #{@tool}" unless @tool == :defect || @tool == :feature
         Command.new(:approval, :accept, @exec_mode, {:"accept -#{@tool}" => @name, :become => become, :release => release}).exec
         return self
      end
   end

end
