# This module provides methods to help manage configuration information.
# It is included into any object that wants to provide configuration.
# any class with this module gains methods set/enable/disable.
# each of these defines further methods depending on their arguments.
# That works by defining new methods that can fetch and update the value.
# e.g.,
# class Foo
#    include Config
#    set :biz, 5
#    enable :works, :how
#    disable :nice
#    def bar
#       return 3 if biz == 5
#       return 8 if works?
#       return 9
#       enable :nice
#    end
# end
#
# You can even provide a block, which will be evaluated whenever the value
# is queried. This is useful for computing answers, or having properties
# that depend on side-effects that have yet to come to pass.
#
# clsas Foo
#   include Config
#   set :wonky, Proc.new { self.instance_methods }
# end

module Config
   # Defines a method on the container class.
   # class Foo
   #    def whoa
   #      metadef(:hey) { p "hey there" }
   #    end
   # end
   # f=Foo.new
   # f.whoa # will enable us to also call hey
   # f.hey  # prints "hey there"
   def metadef message, &block
      (class << self; self; end).send :define_method, message, &block
   end

   # Set an ar
   def set option, value=self, &block
      raise ArgumentError if block && value != self
      value = block if block
      if value.kind_of?(Proc)
         metadef("#{option}", &value)
         metadef("#{option}?") { !!__send__(option) }
         metadef("#{option}=") { |val| set(option, Proc.new{val}) }
      elsif value == self && option.respond_to?(:to_hash)
         option.to_hash.each {|k,v| set(k,v) }
      elsif respond_to?("{option}=")
         __send__ "#{option}=", value
      else
         set option, Proc.new{value}
      end
      self
   end

   # set all arguments to true.
   def enable *opts
      opts.each { |key| set(key, true) }
   end

   # set all arguments to false
   def disable *opts
      opts.each { |key| set(key, false) }
   end
end

