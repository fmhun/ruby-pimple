class Pimple < Hash
  
  VERSION = '0.0.1.alpha'
  
  def initialize(parameters={})
    self.replace(parameters)
  end
  
  def [](key)
    obj = self.fetch key
    obj.kind_of?(Proc) ? obj.call(self) : obj
  rescue
    raise KeyError, "Identifier \"#{key}\" is not defined."
  end
  
  def protect
    raise ArgumentError, "Missing block for protected function" unless block_given?
    Proc.new { yield }
  end
  
  def share
    raise ArgumentError, "Missing block for shared service" unless block_given?
    lambda do |c|
      @object ||= yield(self)
      @object
    end
  end
  
  def extend
    # Not implemented yet
  end
  
end