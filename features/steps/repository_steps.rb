require 'spec'
$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'giternal'

class GiternalHelper
  @@giternal_base = File.expand_path(File.dirname(__FILE__) + '/../../')
  
  def self.create_main_repo
    FileUtils.mkdir_p tmp_path
    Dir.chdir(tmp_path) do
      FileUtils.mkdir "main_repo"
      `cd main_repo && git init`
    end
  end

  def self.tmp_path
    "/tmp/giternal_test"
  end

  def self.giternal_base
    @@giternal_base
  end

  def self.run(*args)
    `#{giternal_base}/bin/giternal #{args.join(' ')}`
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
      GiternalHelper.run('update')
    end
  end

  def self.freeze_externals
    Dir.chdir(tmp_path + '/main_repo') do
      GiternalHelper.run('freeze')
    end
  end

  def self.unfreeze_externals
    Dir.chdir(tmp_path + '/main_repo') do
      GiternalHelper.run('unfreeze')
    end
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

  def self.add_external_to_ignore(repo_name)
    Dir.chdir(tmp_path + '/main_repo') do
      `echo 'dependencies/#{repo_name}' >> .gitignore`
    end
  end
end

def be_up_to_date
  Spec::Matchers::SimpleMatcher.new("a giternal'd repository") do |repo_name|
    File.directory?(GiternalHelper.checked_out_path(repo_name)).should == true
    GiternalHelper.repo_contents(GiternalHelper.checked_out_path(repo_name)) ==
      GiternalHelper.repo_contents(GiternalHelper.external_path(repo_name))
  end
end

def be_a_git_repo
  Spec::Matchers::SimpleMatcher.new("a giternal'd repository") do |repo_name|
    File.directory?(GiternalHelper.checked_out_path(repo_name) + '/.git')
  end
end

def be_added_to_commit_index
  Spec::Matchers::SimpleMatcher.new("a giternal'd repository") do |repo_name|
    Dir.chdir(GiternalHelper.tmp_path + '/main_repo') do
      status = `git status`
      flattened_status = status.split("\n").join(" ")
      to_be_committed_regex = /new file:\W+dependencies\/#{repo_name}/
      untracked_files_regex = /Untracked files:.*#{repo_name}/
      status =~ to_be_committed_regex && !(flattened_status =~ untracked_files_regex)
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

Given "the externals are up to date" do
  GiternalHelper.update_externals
end

Given "the externals are frozen" do
  GiternalHelper.freeze_externals
end

Given /content is added to '(.*)'/ do |repo_name|
  GiternalHelper.add_content(repo_name)
end

Given /^the external '(.*)' has been added to \.gitignore$/ do |repo_name|
  GiternalHelper.add_external_to_ignore(repo_name)
end

When "I update the externals" do
  GiternalHelper.update_externals
end

When "I freeze the externals" do
  GiternalHelper.freeze_externals
end

When "I unfreeze the externals" do
  GiternalHelper.unfreeze_externals
end

Then /'(.*)' should be checked out/ do |repo_name|
  repo_name.should be_up_to_date
end

Then /'(.*)' should be up to date/ do |repo_name|
  repo_name.should be_up_to_date
end

Then /'(.*)' should not be up to date/ do |repo_name|
  repo_name.should_not be_up_to_date
end

Then /'(.*)' should no longer be a git repo/ do |repo_name|
  repo_name.should_not be_a_git_repo
end

Then /'(.*)' should be a git repo/ do |repo_name|
  repo_name.should be_a_git_repo
end

Then /'(.*)' should be added to the commit index/ do |repo_name|
  repo_name.should be_added_to_commit_index
end

Then /'(.*)' should be removed from the commit index/ do |repo_name|
  repo_name.should_not be_added_to_commit_index
end
