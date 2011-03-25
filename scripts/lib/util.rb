# where I shove my useful junk.



# Given a thing, yields it, then returns it
# Lets me write this:
# def foo
#   returning Hash.new do |h|
#    h["foo"] = :bar
#   end
# end
def returning i
   yield i
   return i
end

# Very simple helper, parms is a hash that must define all keys in the list
def must_contain(parms, list)
   list.each do |i|
      raise "#{i.to_s} required" unless parms[i]
   end
end



# Just a base-converison, from hexdigits into base-62.
# sha_to_b62("50") == "1i"
# I mostly use the with the entropy routines below
def sha_to_b62 sha
   sint = sha.to_i(16)
   res = ""
   digits = ("0".."9").to_a + ("a".."z").to_a + ("A".."Z").to_a
   while sint > 0
      rest,units = sint.divmod(62)
      res = digits[units] + res
      sint = rest
   end
   return res
end

ENTROPY_FILE = "#{ENV["HOME"]}/.entropy"

# Keep a file with entropy in my home directory, and provide methods to read and write it
# My biggest use for this is for creating random seeds.
def entropy e=ENTROPY_FILE
   return rand.to_s unless File.exist? e
   if !File.exist? e
      return sha_to_b64 Digest::SHA1.hexdigest("#{Time.now.to_f}#{rand}-kickoff")
   end
   File.open e, "r" do |f|
      return f.readlines.chomp
   end
end

# Will open the entropy file, hash it's contents together with your argument, and
# write it back to the file.
def add_entropy addition, e=ENTROPY_FILE
   require 'digest/sha1'
   old = entropy e
   returning sha_to_b64(Digest::SHA1.hexdigest("#{Time.now.to_f}#{addition}#{rand}#{old}")) do |new_entropy|
     File.open e, "w" do |f|
         f.write new_entropy
      end
   end
end

# Puts the current environment into a hash table, splitting any arrays up
def environment_as_hash
   returning Hash.new do |h|
      ENV.keys.each do |k|
         if k && k =~ /:/
            h[k] = ENV[k].split ':'
         else
            h[k] = ENV[k]
         end
      end
   end
end



def sys
   `uname -s`.chomp.downcase.to_sym
end

# This wraps up vesion determination in a way similar to other tools
def linux_version
   case ENV['MACHTYPE']
   when "s390x-suse-linux"
      :sles_zlnx
   when /^i[356]86/
      if File.exist? "/etc/fedora-release"
         :linux_ia32_cell
      else
         :linux_ia32
      end
   else
      if    File.exist? "/etc/rhel-release"
         :rhel
      elsif File.exist? "/etc/redhat-release"
         `awk '/release 5/||/release 4.9/{v=5};/release 4/{v=4}; END {print "rhel" v}' /etc/redhad-release`.to_sym
      elsif File.exist? "/etc/SuSE-release"
         `awk '$1=="VERSION" { v=$3}; END { print "sles" v}' /etc/SuSE-release`.to_sym
      elsif File.exist? "/etc/yellowdog-release"
         :yhpc
      else
         :rhel
      end
   end
end
