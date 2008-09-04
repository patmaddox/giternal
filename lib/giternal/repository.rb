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
      if File.exist?(target_path + "/#{@name}")
        if !File.exist?(target_path + "/#{@name}/.git")
          raise "Directory '#{@name}' exists but is not a git repository"
        else
          `cd #{target_path}/#{@name} && git pull 2>&1`
        end
      else
        `cd #{target_path} && git clone #{@repo_url} #{@name}`
      end
      true
    end

    def freezify(target_dir)
      target_path = File.expand_path(File.join(target_dir, @rel_path, @name))
      FileUtils.mv(target_path + '/.git', target_path + '/.git.frozen')
    end
  end
end
