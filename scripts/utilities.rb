
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
