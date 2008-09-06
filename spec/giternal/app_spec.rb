require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

module Giternal
  describe App do
    before(:each) do
      @app = App.new("some_fake_dir")
      @mock_config = stub("config", :null_object => true)
    end

    describe "loading the config file" do
      before(:each) do
        File.stub!(:file?).and_return true
        File.stub!(:read).and_return "yaml config"
        YamlConfig.stub!(:new).and_return @mock_config
      end

      it "should exit with an error when no config file exists" do
        File.should_receive(:file?).with(/some_fake_dir\/config\/giternal\.yml/).and_return false
        $stderr.should_receive(:puts)
        @app.should_receive(:exit).with(1)
        @app.config
      end

      it "should create a config from the config file" do
        YamlConfig.should_receive(:new).with('some_fake_dir', "yaml config").and_return @mock_config
        @app.config
      end
    end

    describe "app actions" do
      before(:each) do
        @app.stub!(:config).and_return @mock_config
        @mock_repo = mock("repo")
        @mock_config.stub!(:each_repo).and_yield(@mock_repo)
      end

      it "should update each of the repositories" do
        @mock_repo.should_receive(:update)
        @app.update
      end

      it "should freeze each of the repositories" do
        @mock_repo.should_receive(:freezify)
        @app.freezify
      end

      it "should unfreeze each of the repositories" do
        @mock_repo.should_receive(:unfreezify)
        @app.unfreezify
      end
    end
  end
end
