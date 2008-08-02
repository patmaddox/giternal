begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'giternal'

module GiternalTest
  def self.base_project_dir
    File.expand_path(File.dirname(__FILE__) + '/test_repos')
  end

  def self.source_dir(name)
    base_project_dir + '/' + name
  end

  def self.create_repo(name)
    repo_path = source_dir(name)
    FileUtils.mkdir_p(repo_path)
    `cd #{repo_path} && git init && echo #{name} > #{name} && git add #{name} && git commit -m "added #{name}"`
  end

  def self.wipe_repos
    FileUtils.rm_rf(base_project_dir) if File.directory?(base_project_dir)
  end
end

Spec::Runner.configuration.before(:each) do
  GiternalTest.wipe_repos
end

Spec::Runner.configuration.after(:each) do
  GiternalTest.wipe_repos
end
