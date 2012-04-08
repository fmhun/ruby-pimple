$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'simplecov'

SimpleCov.start do
  add_group 'Libraries', 'lib'
end

require 'pimple'

RSpec.configure do |config|
	config.filter_run_excluding :broken => true
end