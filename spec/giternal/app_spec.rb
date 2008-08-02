require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

module Giternal
  describe App do
    before(:each) do
      @app = App.new("some_fake_dir")
      File.stub!(:file?).and_return true
      File.stub!(:read).and_return "yaml config"

      @mock_config = stub("config", :null_object => true)
      YamlConfig.stub!(:new).and_return @mock_config
    end

    it "should exit with an error when no config file exists" do
      File.should_receive(:file?).with(/some_fake_dir\/config\/giternal\.yml/).and_return false
      $stderr.should_receive(:puts)
      @app.should_receive(:exit).with(1)
      @app.run
    end

    it "should create a config from the config file" do
      YamlConfig.should_receive(:new).with("yaml config").and_return @mock_config
      @app.run
    end

    it "should update each of the repositories" do
      mock_repo = mock("repo")
      mock_repo.should_receive(:update).with('some_fake_dir')
      @mock_config.stub!(:each_repo).and_yield(mock_repo)
      @app.run
    end
  end
end
