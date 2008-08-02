require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

module Giternal
  describe Repository do
    it "should check itself out to a dir" do
      GiternalTest.create_repo 'foo'
      repository = Repository.new("foo", GiternalTest.source_dir('foo'),
                                  'deps')
      repository.update GiternalTest.base_project_dir
      File.directory?(GiternalTest.base_project_dir + '/deps/foo').should be_true
      File.file?(GiternalTest.base_project_dir + '/deps/foo/foo').should be_true
    end
  end
end
