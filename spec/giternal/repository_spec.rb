require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

module Giternal
  describe Repository do
    before(:each) do
      GiternalTest.create_repo 'foo'
      @repository = Repository.new("foo", GiternalTest.source_dir('foo'),
                                   'deps')
    end
    
    it "should check itself out to a dir" do
      @repository.update GiternalTest.base_project_dir
      File.file?(GiternalTest.base_project_dir + '/deps/foo/foo').should be_true
      File.read(GiternalTest.base_project_dir + '/deps/foo/foo').strip.
        should == 'foo'
    end

    it "should update the repo when it's already been checked out" do
      @repository.update GiternalTest.base_project_dir
      GiternalTest.add_to_repo 'foo', 'newfile'
      @repository.update GiternalTest.base_project_dir
      File.file?(GiternalTest.base_project_dir + '/deps/foo/newfile').should be_true
      File.read(GiternalTest.base_project_dir + '/deps/foo/newfile').strip.
        should == 'newfile'
    end

    it "should raise an error if the directory exists but there's no .git dir" do
      FileUtils.mkdir_p(GiternalTest.source_dir('deps/foo'))
      lambda {
        @repository.update GiternalTest.base_project_dir
      }.should raise_error(/Directory 'foo' exists but is not a git repository/)
    end

    describe "freezify" do
      it "should move the .git dir to .git.frozen" do
        GiternalTest.create_repo('main')
        GiternalTest.create_repo('external')
        @repository = Repository.new('external', GiternalTest.source_dir('external'),
                                     'deps')
        @main_dir = GiternalTest.base_project_dir + '/main'
        @repository.update @main_dir

        File.directory?(@main_dir + '/deps/external/.git').should be_true
        @repository.freezify(@main_dir)
        File.directory?(@main_dir + '/deps/external/.git.frozen').should be_true
        File.directory?(@main_dir + '/deps/external/.git').should be_false
      end
    end
  end
end
