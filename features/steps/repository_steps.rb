require 'spec'
$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'giternal'

class GiternalHelper
  @@tmp_path = File.expand_path(File.dirname(__FILE__) + '/../tmp')
  
  def self.create_main_repo
    FileUtils.mkdir_p tmp_path
    Dir.chdir(tmp_path) do
      FileUtils.mkdir "main_repo"
    end
  end

  def self.tmp_path
    @@tmp_path
  end

  def self.create_repo(repo_name)
    Dir.chdir(tmp_path) do
      FileUtils.mkdir_p "externals/#{repo_name}"
      `cd externals/#{repo_name} && git init`
    end
    add_to_config_file repo_name
  end

  def self.add_to_config_file(repo_name)
    config_dir = tmp_path + '/main_repo/config'
    FileUtils.mkdir(config_dir) unless File.directory?(config_dir)
    Dir.chdir(config_dir) do
      `echo #{repo_name}: >> giternal.yml`
      `echo '  repo: #{external_path(repo_name)}' >> giternal.yml`
      `echo '  path: dependencies' >> giternal.yml`
    end
  end

  def self.add_content(repo_name)
    Dir.chdir(tmp_path + "/externals/#{repo_name}") do
      `echo foo >> foo && git add foo`
      `git commit foo -m "added content to foo"`
    end
  end

  def self.external_path(repo_name)
    File.expand_path(tmp_path + "/externals/#{repo_name}")
  end

  def self.checked_out_path(repo_name)
    File.expand_path(tmp_path + "/main_repo/dependencies/#{repo_name}")
  end

  def self.clean!
    FileUtils.rm_rf tmp_path
  end

  def self.update_externals
    Dir.chdir(tmp_path + '/main_repo') do
      `rake -f #{sakefile_path} giternal:update`
    end
  end

  def self.sakefile_path
    File.expand_path(tmp_path + '/../../lib/tasks/giternal.rake')
  end

  def self.repo_contents(path)
    Dir.chdir(path) do
      contents = `git cat-file -p HEAD`
      unless contents.include?('tree') && contents.include?('author')
        raise "something is wrong with the repo, output doesn't contain expected git elements:\n\n #{contents}"
      end
      contents
    end
  end
end

Before do
  GiternalHelper.clean!
  GiternalHelper.create_main_repo
end

After do
#  GiternalHelper.clean!
end

Given /an external repository named '(.*)'/ do |repo_name|
  GiternalHelper.create_repo repo_name
  GiternalHelper.add_content repo_name
end

Given /'(.*)' is not yet checked out/ do |repo_name|
  # TODO: Figure out why I can't use should be_false here
  File.directory?(GiternalHelper.checked_out_path(repo_name)).should == false
end

When "I update the externals" do
  GiternalHelper.update_externals
end

Then /'(.*)' should be checked out/ do |repo_name|
  File.directory?(GiternalHelper.checked_out_path(repo_name)).should == true
  GiternalHelper.repo_contents(GiternalHelper.checked_out_path(repo_name)).should ==
    GiternalHelper.repo_contents(GiternalHelper.external_path(repo_name))
end
