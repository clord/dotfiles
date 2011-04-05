#!/usr/bin/env ruby
#
# Perform a set operation such as union, intersection, or subtraction. I use these most often
# when dealing with a set of testlists that I'm manipulating while finding regressions.
# but they would also come in useful in many other contexts.
#

require 'set'
require 'fileutils'
include FileUtils

if ARGV.empty?
   STDERR.puts "At least one argument is required"
   exit 1
end

# Reads the first command line argument into LHS, and all remaining command line arguments
# (or STDIN if none specified) and performs a set operation between the lines of LHS and the RHS.
# The operation is determined by the name of the script

lhs = Set.new
rhs = Set.new


# first argument
File.open(ARGV.shift, "r") do |f|
   lhs.merge(f.readlines)
end

# ARGF will consist of the contents of all files on the command line, concatinated, or STDIN
rhs.merge(ARGF.readlines)

scriptname = File.basename($0).intern

newset = lhs.send(scriptname, rhs)

newset.delete_if do |o|
   o =~ /^\s*$/
end

newset.each do |i|
   STDOUT.puts i
end

