require 'yaml'

module Giternal
  class YamlConfig
    def initialize(base_dir, yaml_string)
      @base_dir = base_dir
      @config_hash = YAML.load yaml_string
    end

    def each_repo
      repositories.each { |r| yield(r) if block_given? }
    end

    def find_repo(path)
      @config_hash.each do |name, attributes|
        if path == File.join(attributes["path"], name)
          return Repository.new(@base_dir, name, attributes["repo"], attributes["path"])
        end
      end
      return nil
    end

    private
    def repositories
      @config_hash.map do |name, attributes|
        Repository.new(@base_dir, name, attributes["repo"], attributes["path"], attributes["branch"])
      end
    end
  end
end
