(in /Users/pergesu/work/giternal)
Gem::Specification.new do |s|
  s.name = %q{giternal}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pat Maddox"]
  s.date = %q{2008-08-02}
  s.default_executable = %q{giternal}
  s.description = %q{description of gem}
  s.email = ["pat.maddox@gmail.com"]
  s.executables = ["giternal"]
  s.extra_rdoc_files = ["History.txt", "License.txt", "Manifest.txt", "PostInstall.txt", "README.txt", "website/index.txt"]
  s.files = ["History.txt", "License.txt", "Manifest.txt", "PostInstall.txt", "README.txt", "Rakefile", "bin/giternal", "config/hoe.rb", "config/requirements.rb", "lib/giternal.rb", "lib/giternal/app.rb", "lib/giternal/repository.rb", "lib/giternal/version.rb", "lib/giternal/yaml_config.rb", "script/console", "script/destroy", "script/generate", "script/txt2html", "setup.rb", "spec/giternal/app_spec.rb", "spec/giternal/repository_spec.rb", "spec/giternal/yaml_config_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "tasks/deployment.rake", "tasks/environment.rake", "tasks/rspec.rake", "tasks/website.rake", "website/index.html", "website/index.txt", "website/javascripts/rounded_corners_lite.inc.js", "website/stylesheets/screen.css", "website/template.html.erb"]
  s.has_rdoc = true
  s.homepage = %q{http://giternal.rubyforge.org}
  s.post_install_message = %q{In your project root, create a file called config/giternal.yml.  This
file should contain a list of externals in the following format:

name:
  repo: git://url/to/repo.git
  path: local/path/dir

For example, to add the rspec and rspec-rails plugins to your project,
add the following to config/giternal.yml

rspec:
  repo: git://github.com/dchelimsky/rspec.git
  path: vendor/plugins
rspec-rails:
  repo: git://github.com/dchelimsky/rspec-rails.git
  path: vendor/plugins

For more information on giternal, see http://giternal.rubyforge.org


}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{giternal}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{description of gem}
  s.test_files = ["spec/giternal/app_spec.rb", "spec/giternal/repository_spec.rb", "spec/giternal/yaml_config_spec.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_development_dependency(%q<hoe>, [">= 1.7.0"])
    else
      s.add_dependency(%q<hoe>, [">= 1.7.0"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.7.0"])
  end
end
