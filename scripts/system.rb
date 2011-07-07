#!/usr/bin/env ruby


def screen_command machine
   case machine
   when :pape
      "/home/clord/Linux/bin/screen"
   when :brimley
      "/home/clord/Linux/bin/screen"
   when :sparky
      "/usr/local/bin/screen"
   when :bloor
      "/home/clord/AIX/bin/screen"
   else
      raise "unknown machine"
   end
end


def screen_on machine, session
   "/usr/bin/ssh -XC clord@#{machine} -t #{screen_command(machine)} -c /home/clord/dotfiles/screenrc/s#{session}"
end


if ARGV.empty?
   STDERR.puts "At least one argument is required"
   exit 1
end

ENV['TERM'] = "xterm"
script_name = File.basename $0

command = screen_on script_name.to_sym, ARGV.shift

exec command


