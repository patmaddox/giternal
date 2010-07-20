module Giternal
  class App
    def initialize(base_dir)
      @base_dir = base_dir
    end

    def update
      config.each_repo {|r| r.update }
    end

    def freezify(*dirs)
      if dirs.empty?
        config.each_repo {|r| r.freezify }
      else
        dirs.each do |dir|
          if repo = config.find_repo(dir)
            repo.freezify
          end
        end
      end
    end

    def unfreezify(*dirs)
      if dirs.empty?
        config.each_repo {|r| r.unfreezify }
      else
        dirs.each do |dir|
          if repo = config.find_repo(dir)
            repo.unfreezify
          end
        end
      end
    end

    def run(action, *args)
      case action
      when "freeze"
        freezify(*args)
      when "unfreeze"
        unfreezify(*args)
      else
        send(action, *args)
      end
    end

    def config
      return @config if @config

      config_file = ['config/giternal.yml', '.giternal.yml'].detect do |file|
        File.file? File.expand_path(@base_dir + '/' + file)
      end

      if config_file.nil?
        $stderr.puts "config/giternal.yml is missing"
        exit 1
      end

      @config = YamlConfig.new(@base_dir, File.read(config_file))
    end
  end
end
