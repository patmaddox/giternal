require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

module Giternal
  describe YamlConfig do
    it "should create repositories from the config" do
      config = YamlConfig.new("rspec:\n  repo: git://rspec\n  path: vendor/plugins\n" +
                              "foo:\n  repo: git://at/foo\n  path: path/to/foo\n")
      Repository.should_receive(:new).with("rspec", "git://rspec", "vendor/plugins").and_return :a_repo
      Repository.should_receive(:new).with("foo", "git://at/foo", "path/to/foo").and_return :a_repo
      config.each_repo {|r| r.should == :a_repo}
    end
  end
end
