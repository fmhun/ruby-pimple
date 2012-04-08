require 'spec_helper'

describe Pimple do
  
  describe '.new' do
    
    it 'should be a type of Hash' do
      Pimple.new.kind_of?(Hash).should be_true 
    end
    
    it 'should initialize with parameters' do
      params = { :redis_classname => 'Redis' }
      Pimple.new(params)[:redis_classname].should == 'Redis'
    end
    
  end
  
  describe '.[]' do
    let(:container) { Pimple.new }
    before { class Facebook; end; } # Simulate Facebook Api Client class
    
    it 'should inject service' do
      container[:facebook] = lambda { |c| Facebook.new }
      container[:facebook].class.should equal(Facebook)
    end
    
    it 'should return a new instance each time the [](key) method is invoked' do
      container[:facebook] = lambda { |c| Facebook.new }
      container[:facebook].should_not equal(container[:facebook])
    end
    
    it 'should raise KeyError if service not found' do
      lambda { container[:notfound] }.should raise_error(KeyError)
    end
    
  end
  
  describe '.protect' do
    let(:container) { Pimple.new }
    
    it 'should define anonymous function as parameter' do
      container[:lambda_param] = container.protect { rand(1000) }
      container[:lambda_param].should_not equal(container[:lambda_param])
    end
    
    it 'should define anonymous function as parameter by Proc.new way' do
      container[:lambda_param] = Proc.new { rand(1000) }
      container[:lambda_param].should_not equal(container[:lambda_param])
    end
    
    it 'should raise ArgumentError when block is missing' do
      lambda { container.protect }.should raise_error(ArgumentError)
    end
    
  end
  
  describe '.share' do
    let(:container) { Pimple.new }
    before { class Facebook; end; } # Simulate Facebook Api Client class
    
    it 'should define shared (global) service' do
      container[:facebook] = container.share { |c| Facebook.new }
      container[:facebook].class.should equal(Facebook)
    end
    
    it 'should get the same instance each time [](key) method is invoked' do
       container[:facebook] = container.share { |c| Facebook.new }
       container[:facebook].should equal(container[:facebook])
    end
    
  end
  
  describe '.extend', :pending => true do
    
  end
  
end