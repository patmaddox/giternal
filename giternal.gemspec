# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{giternal}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pat Maddox"]
  s.date = %q{2009-04-04}
  s.default_executable = %q{giternal}
  s.email = %q{pat.maddox@gmail.com}
  s.executables = ["giternal"]
  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
  s.files = ["README.rdoc", "VERSION.yml", "bin/giternal", "lib/giternal", "lib/giternal/app.rb", "lib/giternal/repository.rb", "lib/giternal/version.rb", "lib/giternal/yaml_config.rb", "lib/giternal.rb", "spec/giternal", "spec/giternal/app_spec.rb", "spec/giternal/repository_spec.rb", "spec/giternal/yaml_config_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "LICENSE"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/pat-maddox/giternal}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{TODO}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
