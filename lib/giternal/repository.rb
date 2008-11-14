require 'fileutils'

module Giternal
  class Repository
    def initialize(base_dir, name, repo_url, rel_path)
      @base_dir = base_dir
      @name = name
      @repo_url = repo_url
      @rel_path = rel_path
    end

    def update
      return true if frozen?
      FileUtils.mkdir_p checkout_path unless File.exist?(checkout_path)
      if checked_out?
        if !File.exist?(repo_path + '/.git')
          raise "Directory '#{@name}' exists but is not a git repository"
        else
					update_output { `cd #{repo_path} && git pull 2>&1` }
        end
      else
        update_output { `cd #{checkout_path} && git clone #{@repo_url} #{@name}` }
      end
      true
    end

    def freezify
      return true if frozen? || !checked_out?

      Dir.chdir(repo_path) do
        `tar czf .git.frozen.tgz .git`
        FileUtils.rm_r('.git')
      end
      `cd #{@base_dir} && git add -f #{rel_repo_path}`
      true
    end

    def unfreezify
      return true unless frozen?

      Dir.chdir(repo_path) do
        `tar xzf .git.frozen.tgz`
        FileUtils.rm('.git.frozen.tgz')
      end
      `cd #{@base_dir} && git rm -r --cached #{rel_repo_path}`
      true
    end

    def frozen?
      File.exist?(repo_path + '/.git.frozen.tgz')
    end

    def checked_out?
      File.exist?(repo_path)
    end

    private
    def checkout_path
      File.expand_path(File.join(@base_dir, @rel_path))
    end

    def repo_path
      File.expand_path(checkout_path + '/' + @name)
    end

    def rel_repo_path
      @rel_path + '/' + @name
    end

		def update_output(&block)
			puts "Updating #{@name}"
			block.call
			puts " ..updated"
			puts
		end
  end
end
