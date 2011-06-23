require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "#{ENV["GEM_PREFIX"]}giternal"
    gem.summary = %Q{Non-sucky git externals}
    gem.description = %Q{Giternal provides dead-simple management of external git dependencies. It only stores a small bit of metadata, letting you actively develop in any of the repos. Come deploy time, you can easily freeze freeze all the dependencies to particular versions}
    gem.email = "pat.maddox@gmail.com"
    gem.homepage = "http://github.com/pat-maddox/giternal"
    gem.authors = ["Pat Maddox"]
    gem.add_development_dependency "rspec"
    gem.add_development_dependency "cucumber"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :spec => :check_dependencies

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)

  task :features => :check_dependencies
rescue LoadError
  task :features do
    abort "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
  end
end

task :default => [:spec, :features]

#Rake::RDocTask.new do |rdoc|
#  if File.exist?('VERSION')
#    version = File.read('VERSION')
#  else
#    version = ""
#  end
#
#  rdoc.rdoc_dir = 'rdoc'
#  rdoc.title = "giternal #{version}"
#  rdoc.rdoc_files.include('README*')
#  rdoc.rdoc_files.include('lib/**/*.rb')
#end
