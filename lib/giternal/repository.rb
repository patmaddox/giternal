module Giternal
  class Repository
    def initialize(base_dir, name, repo_url, rel_path)
      @base_dir = base_dir
      @name = name
      @repo_url = repo_url
      @rel_path = rel_path
    end

    def update
      FileUtils.mkdir_p checkout_path unless File.exist?(checkout_path)
      if File.exist?(repo_path)
        if !File.exist?(repo_path + '/.git')
          raise "Directory '#{@name}' exists but is not a git repository"
        else
          `cd #{repo_path} && git pull 2>&1`
        end
      else
        `cd #{checkout_path} && git clone #{@repo_url} #{@name}`
      end
      true
    end

    def freezify
      FileUtils.mv(repo_path + '/.git', repo_path + '/.git.frozen')
    end

    private
    def checkout_path
      File.expand_path(File.join(@base_dir, @rel_path))
    end

    def repo_path
      File.expand_path(checkout_path + '/' + @name)
    end
  end
end
