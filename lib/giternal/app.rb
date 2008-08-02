module Giternal
  class App
    def initialize(base_dir)
      @base_dir = base_dir
    end

    def run
      config_file = File.expand_path(@base_dir + '/config/giternal.yml')
      unless File.file?(config_file)
        $stderr.puts "config/giternal.yml is missing"
        exit 1
      end

      config = YamlConfig.new File.read(config_file)
      config.each_repo {|r| r.update(@base_dir) }
    end
  end
end
