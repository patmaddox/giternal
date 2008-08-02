require 'yaml'

module Giternal
  class YamlConfig
    def initialize(yaml_string)
      @config_hash = YAML.load yaml_string
    end

    def each_repo
      repositories.each { |r| yield(r) if block_given? }
    end

    private
    def repositories
      @config_hash.map do |name, attributes|
        Repository.new(name, attributes["repo"], attributes["path"])
      end
    end
  end
end
