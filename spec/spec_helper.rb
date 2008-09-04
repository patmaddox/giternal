begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'giternal'
require 'fileutils'

module GiternalTest
  def self.base_project_dir
    File.expand_path(File.dirname(__FILE__) + '/test_repos')
  end

  def self.source_dir(name)
    base_project_dir + '/' + name
  end

  def self.create_repo(name)
    FileUtils.mkdir_p(source_dir(name))
    `cd #{source_dir(name)} && git init`
    add_to_repo name, name
  end

  def self.add_to_repo(repo_name, file)
    `cd #{source_dir(repo_name)} && echo #{file} > #{file} && git add #{file} && git commit -m "added #{file}"`
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
