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

    it 'should inject service' do
      container[:service] = lambda { |c| Service.new }
      container[:service].class.should equal(Service)
    end

    it 'should inject configuring service from container parameters' do
      container[:foo] = 'bar'
      container[:service] = lambda { |c| Service.new(c[:foo]) }
      container[:service].param.should == 'bar'
    end

    it 'should return a new instance each time the [](key) method is invoked' do
      container[:service] = lambda { |c| Service.new }
      container[:service].should_not equal(container[:service])
    end

    it 'should raise KeyError if service not found' do
      lambda { container[:notfound] }.should raise_error(KeyError)
    end
  end

  describe '.protect' do
    let(:container) { Pimple.new }

    it 'should define anonymous function as parameter' do
      container[:protected] = container.protect { rand(1000) }
      container[:protected].should_not equal(container[:protected])
    end

    it 'should define anonymous function as parameter by Proc.new way' do
      container[:protected] = Proc.new { rand(1000) }
      container[:protected].should_not equal(container[:protected])
    end

    it 'should raise ArgumentError when block is missing' do
      lambda { container.protect }.should raise_error(ArgumentError)
    end

    describe "with method missing" do
      let(:container) { Pimple.new }

      it 'should define anonymous function as parameter' do
        container.protected(:protect => true) { rand(1000) }
        container[:protected].should_not equal(container[:protected])
      end

      let(:container) { Pimple.new }

      it 'should define anonymous function as parameter by Proc.new way' do
         container.protected(:protect => true) { rand(1000) }
        container[:protected].should_not equal(container[:protected])
      end

      it 'should raise ArgumentError when block is missing' do
        lambda { container.protect }.should raise_error(ArgumentError)
      end
    end

    describe "with set" do
      let(:container) { Pimple.new }

      it 'should define anonymous function as parameter' do
        container.set(:protected,:protect => true) { rand(1000) }
        container[:protected].should_not equal(container[:protected])
      end

      let(:container) { Pimple.new }

      it 'should define anonymous function as parameter by Proc.new way' do
         container.set(:protected,:protect => true) { rand(1000) }
        container[:protected].should_not equal(container[:protected])
      end

      it 'should raise ArgumentError when block is missing' do
        lambda { container.protect }.should raise_error(ArgumentError)
      end
    end
  end

  describe '.share' do
    let(:container) { Pimple.new }

    it 'should define shared service' do
      container[:service] = container.share { |c| Service.new }
      container[:service].class.should equal(Service)
    end

    it 'should inject configuring shared service from container parameters' do
      container[:foo] = 'bar'
      container[:service] = container.share { |c| Service.new(c[:foo]) }
      container[:service].param.should == 'bar'
    end

    it 'should get the same instance each time [](key) method is invoked' do
      container[:service] = container.share { |c| Service.new }
      container[:service].should equal(container[:service])
    end

    describe "shared with get and method missing" do
      let(:container) { Pimple.new }

      it 'should get the same instance each time [](key) method is invoked' do
        container.foo 'bar'
        container.service(:share => true) { |c| Service.new(c[:foo]) }
        container.service.should equal(container[:service])
      end
    end

    describe "shared with set" do
      let(:container) { Pimple.new }

      it 'should get the same instance each time [](key) method is invoked' do
        container.foo 'bar'
        container.set :service, share:true,value:Service.new(container.foo)
        container.service.should equal(container[:service])
      end
    end
  end

  describe '.raw' do
    let(:container) { Pimple.new }

    it 'should return the anonymous function for the defined serivce' do
      container[:service] = lambda { |c| Service.new }
      container.raw(:service).kind_of?(Proc).should be_true
    end

    it 'should raise KeyError exception if service not defined' do
      lambda { container.raw :notfound }.should raise_error(KeyError)
    end
  end

  describe '.extends' do
    let(:container) { Pimple.new }

    it 'should extend a service definition' do
      container[:service] = lambda { |c| Service.new }
      container[:service] = container.extends(:service) do |service, c|
        service.param = 'foo'
        service
      end
      container[:service].param.should == 'foo'
    end

    it 'should extend a shared service definition' do
      container[:service] = container.share { |c| Service.new }
      container[:service] = container.extends(:service) do |service, c|
        service.param = 'foo'
        service
      end
      container[:service].should equal(container[:service])
      container[:service].param.should == 'foo'
    end

    it 'should extend protected parameter' do
      container[:protected] = container.protect { rand(100) }
      container[:protected] = container.extends(:protected) do |p, c|
        p + 200
      end
      container[:protected].should_not == container[:protected]
    end

    it 'should not extend parameter' do
      container[:foo] = 'bar'
      lambda {
        container.extends(:foo) { |p, c| 'foo' }
      }.should raise_error(ArgumentError)
    end

    it 'should raise KeyError if service not found' do
      lambda {
        container.extends(:notfound) { |p, c| }
      }.should raise_error(KeyError)
    end
  end
end
