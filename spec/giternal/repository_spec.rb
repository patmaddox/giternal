require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

module Giternal
  describe Repository do
    before(:each) do
      GiternalTest.create_repo 'foo'
      @repository = Repository.new(GiternalTest.base_project_dir, "foo",
                                   GiternalTest.source_dir('foo'),
                                   'deps')
    end

    it "should check itself out to a dir" do
      @repository.update
      File.file?(GiternalTest.base_project_dir + '/deps/foo/foo').should be_true
      File.read(GiternalTest.base_project_dir + '/deps/foo/foo').strip.
        should == 'foo'
    end

    it "should update the repo when it's already been checked out" do
      @repository.update
      GiternalTest.add_to_repo 'foo', 'newfile'
      @repository.update
      File.file?(GiternalTest.base_project_dir + '/deps/foo/newfile').should be_true
      File.read(GiternalTest.base_project_dir + '/deps/foo/newfile').strip.
        should == 'newfile'
    end

    it "should raise an error if the directory exists but there's no .git dir" do
      FileUtils.mkdir_p(GiternalTest.source_dir('deps/foo'))
      lambda {
        @repository.update
      }.should raise_error(/Directory 'foo' exists but is not a git repository/)
    end

    describe "freezify" do
      before(:each) do
        GiternalTest.create_repo('main')
        GiternalTest.create_repo('external')
        @main_dir = GiternalTest.base_project_dir + '/main'
        @repository = Repository.new(@main_dir, 'external',
                                     GiternalTest.source_dir('external'),
                                     'deps')
        @repository.update
      end

      it "should archive the .git dir" do
        @repository.freezify
        File.file?(@main_dir + '/deps/external/.git.frozen.tgz').should be_true
      end

      it "should get rid of the .git dir" do
        File.directory?(@main_dir + '/deps/external/.git').should be_true
        @repository.freezify
        File.directory?(@main_dir + '/deps/external/.git').should be_false
      end
    end

    it "should simply return if updated when frozen" do
      @repository.update
      @repository.freezify
      lambda { @repository.update }.should_not raise_error
    end

    describe "unfreezify" do
      before(:each) do
        GiternalTest.create_repo('main')
        GiternalTest.create_repo('external')
        @main_dir = GiternalTest.base_project_dir + '/main'
        @repository = Repository.new(@main_dir, 'external',
                                     GiternalTest.source_dir('external'),
                                     'deps')
        @repository.update
        @repository.freezify
      end

      it "should unarchive the .git dir" do
        @repository.unfreezify
        File.directory?(@main_dir + '/deps/external/.git').should be_true
      end

      it "should remove the archived file" do
        @repository.unfreezify
        File.file?(@main_dir + '/deps/external/.git.frozen.tgz').should be_false
      end
    end
  end
end
