#!/usr/bin/env ruby

def screen_command machine
   case machine
   when :pape
      "/home/clord/Linux/bin/screen"
   when :brimley
      "/home/clord/Linux/bin/screen"
   when :sparky, :terran
      "/usr/local/bin/screen"
   when :cfesles
      "/usr/local/bin/screen"
   when :bloor
      "/home/clord/AIX/bin/screen"
   else
      raise "unknown machine"
   end
end

def ssh_to machine
   "/usr/bin/ssh -o SendEnv=STY clord@#{machine}"
end

def screen_on machine, session
   "#{ssh_to machine} -t #{screen_command(machine)} -c /home/clord/dotfiles/screenrc/s#{session}"
end

machine = File.basename($0).to_sym

# Terran has extra terminfo installed (`tic xterm-256color.tic`, where that file came from stdout of infocmp on
# a machine with xterm-256color profile already working)
ENV['TERM'] = "xterm" unless machine == :terran || machine == :sparky

command = if ARGV.empty?
             ssh_to machine
          else
             screen_on machine, ARGV.shift
          end

exec command

exit 1
