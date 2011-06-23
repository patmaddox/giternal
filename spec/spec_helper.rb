begin
  require 'rspec'
rescue LoadError
  require 'rubygems'
  require 'rspec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'giternal'
require 'fileutils'
require 'giternal_test_helper'

RSpec.configure do |config|
  config.before { GiternalHelper.clean! }
  config.after { GiternalHelper.clean! }
end
