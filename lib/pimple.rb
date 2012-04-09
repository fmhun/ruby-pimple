class Pimple < Hash
  
  VERSION = '0.0.3.beta'
  
  # Initialize a container with some default parameters
  def initialize(parameters={})
    self.replace(parameters)
  end
  
  # Get an object.
  # If the fetched object is a lambda, it returns its value.
  # 
  # @params [Symbol, String] key Identifier of the searched elements in the container.
  # 
  # @return [Object]
  def [](key)
    obj = self.fetch key
    obj.kind_of?(Proc) ? obj.call(self) : obj
  rescue
    raise KeyError, "Identifier \"#{key}\" is not defined."
  end
  
  # Create a protected parameter.
  # 
  # @return [Proc]
  #
  # @example
  #   container[:rand] = container.protect { rand(100) }
  #   container[:rand] # => 34
  #   container[:rand] # => 67
  def protect
    raise ArgumentError, "Missing block for protected function" unless block_given?
    Proc.new { yield }
  end
  
  # Create a shared service definition
  # This method require to called with a block that contains service definition
  #
  # @return [Proc]
  # 
  # @example
  #   container[:session] = container.share { |c| Session.new }
  #   container[:session] # => #<Session:0x007>
  #   # Returns the same object later...
  #   container[:session] # => #<Session:0x007>
  def share
    raise ArgumentError, "Missing block for shared service" unless block_given?
    lambda do |c|
      @object ||= yield(self)
      @object
    end
  end
  
  # Get the raw data from the container
  # If you call this method by specifying a service as the key, it will return the Proc.
  #
  # @return [Object, Proc]
  #
  # @example
  #   container[:session] = lambda { |c| Service.new }
  #   container.raw(:service) # => #<Proc:0x007>
  def raw(key)
    self.fetch key
  rescue
    raise KeyError, "Identifier \"#{key}\" is not defined."
  end
  
  # Extend a service definition
  #
  # @param [Symbol, String] key Identifier of the service definition to extend
  #
  # @return [Proc]
  #
  # @example
  #   container[:service] = container.share { |c| Service.new }
  #   container[:service] = container.extend(:service) { |s, c| 
  #     c.configure (:foo, 'bar')
  #     return c # need to return the service object.
  #   }
  def extends(key)
    factory = self.raw(key)
    
    unless factory.kind_of?(Proc)
      raise ArgumentError, "Identifier #{key} does not contain an object definition."
    end
    
    lambda do |c|
      yield(factory.call(c), c)
    end
  end
  
end