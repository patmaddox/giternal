require 'spec'
$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'giternal'
require 'giternal_helper'

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
  GiternalHelper.clean!
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

When /I freeze the external '(.*)'/ do |external_name|
  GiternalHelper.freeze_externals("dependencies/#{external_name}")
end

When "I unfreeze the externals" do
  GiternalHelper.unfreeze_externals
end

When /I unfreeze the external '(.*)'/ do |external_name|
  GiternalHelper.unfreeze_externals("dependencies/#{external_name}")
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
