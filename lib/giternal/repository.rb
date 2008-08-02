module Giternal
  class Repository
    def initialize(name, repo_url, rel_path)
      @name = name
      @repo_url = repo_url
      @rel_path = rel_path
    end

    def update(target_dir)
      target_path = File.expand_path(File.join(target_dir, @rel_path))
      FileUtils.mkdir_p target_path unless File.exist?(target_path)
      `cd #{target_path} && git clone #{@repo_url} #{@name}`
      true
    end
  end
end
