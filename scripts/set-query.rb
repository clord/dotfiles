#!/usr/bin/env ruby
#
# Perform set queries on files and stdin.
# This is useful to:
# - check that a testlist is a subset of another subset
# - determine if all music files in one dir are also in some other directory
# - check set equality without regard to order

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

