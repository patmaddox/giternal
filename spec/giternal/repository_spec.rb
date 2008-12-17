require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

module Giternal
  describe Repository do
    before(:each) do
      GiternalHelper.create_main_repo
      GiternalHelper.create_repo 'foo'
      @repository = Repository.new(GiternalHelper.base_project_dir, "foo",
                                   GiternalHelper.external_path('foo'),
                                   'dependencies')
    end

    it "should check itself out to a dir" do
      @repository.update
      File.file?(GiternalHelper.checked_out_path('foo/foo')).should be_true
      File.read(GiternalHelper.checked_out_path('foo/foo')).strip.
        should == 'foo'
    end

    it "should be ignored from git" do
      @repository.update
      Dir.chdir(GiternalHelper.base_project_dir) do
        # TODO: What I really want is to say it shouldn't include 'foo'
        `git status`.should_not include('dependencies')
      end
    end

    it "should only add itself to .gitignore if it's not already there" do
      2.times { @repository.update }
      Dir.chdir(GiternalHelper.base_project_dir) do
        File.read('.gitignore').scan(/foo/).should have(1).item
        # TODO: What I really want is to say it shouldn't include 'foo'
        `git status`.should_not include('dependencies')
      end
    end

    it "should not show any output when verbose mode is off" do
      @repository.verbose = false
      @repository.should_not_receive(:puts)
      @repository.update
    end

    it "should not show output when verbose mode is on" do
      @repository.verbose = true
      @repository.should_receive(:puts).any_number_of_times
      @repository.update
    end

    it "should update the repo when it's already been checked out" do
      @repository.update
      GiternalHelper.add_content 'foo', 'newfile'
      @repository.update
      File.file?(GiternalHelper.checked_out_path('foo/newfile')).should be_true
      File.read(GiternalHelper.checked_out_path('foo/newfile')).strip.
        should == 'newfile'
    end

    it "should raise an error if the directory exists but there's no .git dir" do
      FileUtils.mkdir_p(GiternalHelper.checked_out_path('foo'))
      lambda {
        @repository.update
      }.should raise_error(/Directory 'foo' exists but is not a git repository/)
    end

    describe "freezify" do
      before(:each) do
        GiternalHelper.create_repo('external')
        @repository = Repository.new(GiternalHelper.base_project_dir, 'external',
                                     GiternalHelper.external_path('external'),
                                     'dependencies')
        @repository.update
      end

      it "should archive the .git dir" do
        @repository.freezify
        File.file?(GiternalHelper.checked_out_path('external/.git.frozen.tgz')).should be_true
      end

      it "should get rid of the .git dir" do
        File.directory?(GiternalHelper.checked_out_path('external/.git')).should be_true
        @repository.freezify
        File.directory?(GiternalHelper.checked_out_path('external/.git')).should be_false
      end
    end

    it "should simply return if updated when frozen" do
      @repository.update
      @repository.freezify
      lambda { @repository.update }.should_not raise_error
    end

    it "should simply return when made to freeze when already frozen" do
      @repository.update
      @repository.freezify
      lambda { @repository.freezify }.should_not raise_error
    end

    it "should simply return when made to freeze before checked out" do
      lambda { @repository.freezify }.should_not raise_error
    end

    it "should simply return when made to unfreeze before checked out" do
      lambda { @repository.unfreezify }.should_not raise_error
    end

    it "should simply return when made to unfreeze when already unfrozen" do
      @repository.update
      lambda { @repository.unfreezify }.should_not raise_error
    end

    describe "unfreezify" do
      before(:each) do
        GiternalHelper.create_repo('main')
        GiternalHelper.create_repo('external')
        @repository = Repository.new(GiternalHelper.base_project_dir, 'external',
                                     GiternalHelper.external_path('external'),
                                     'dependencies')
        @repository.update
        @repository.freezify
      end

      it "should unarchive the .git dir" do
        @repository.unfreezify
        File.directory?(GiternalHelper.checked_out_path('external/.git')).should be_true
      end

      it "should remove the archived file" do
        @repository.unfreezify
        File.file?(GiternalHelper.checked_out_path('external/.git.frozen.tgz')).should be_false
      end
    end
  end
end
