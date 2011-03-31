#!/usr/bin/env ruby

require 'set'
require 'fileutils'
include FileUtils

if ARGV.empty?
   STDERR.puts "At least one argument is required"
   exit 1
end

lhs = Set.new
rhs = Set.new

# first argument
first = ARGV.shift
File.open(first, "r") do |f|
   lhs.merge(f.readlines)
end
lhs.delete_if do |o|
   o =~ /^\s*$/
end

# ARGF will consist of the contents of all files on the command line, concatinated, or STDIN
rhs.merge(ARGF.readlines)
rhs.delete_if do |o|
   o =~ /^\s*$/
end


script = File.basename($0)
method = (script + "?").intern

exit 0 if lhs.send(method, rhs)

STDERR.puts "`cat #{first}`.#{method} returned false"
exit 1

