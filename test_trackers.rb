require 'fileutils'
module Repomanipulator
  def repo_path(path)
    File.expand_path File.join(File.dirname(__FILE__), "test_repos", path)
  end

  def create_repo(name)
    path = repo_path(name)
    FileUtils.mkdir_p(path)
    Dir.chdir(path) do
      `git init`
      `echo first_file > first_file`
    end
    commit_all path, "created repo"
  end

  def commit_all(path, message)
    Dir.chdir(path) do
      `git add .`
      puts `git commit -m "#{message}"`
    end
  end

  def clone_repo(from, to, options=nil)
    Dir.chdir(repo_path("")) { `git clone #{options} #{from} #{to}` }
  end

  def add_content_to(file, content)
    path = repo_path file
    FileUtils.touch path
    File.open(path, 'w') {|f| f << content }
    `cd #{File.dirname(path)} && git checkout master`
    commit_all File.dirname(repo_path(file)), "added content to #{file}"
  end

  def push(repo)
    Dir.chdir(repo_path(repo)) { `git push origin master` }
  end

  def pull(repo)
    Dir.chdir(repo_path(repo)) { puts `git pull` }
  end

  def verify_repo_has_files(repo, *files)
    Dir.chdir(repo_path(repo)) do
      missing_files = files.select {|f| !File.exist?(f) }
      raise "Expected files: [#{missing_files.join(', ')}] to exist in #{repo} but are missing" unless missing_files.empty?
    end
  end
end
include Repomanipulator

module GitSubmodules
  def add_external(base, external)
    external_path = repo_path(external)
    Dir.chdir(repo_path(base)) { puts `git submodule add #{external_path} #{external}` }
    commit_all repo_path(base), "committed external #{external}"
  end

  def update_externals(repo)
    Dir.chdir(repo_path(repo)) do
      puts `git submodule init`
      puts `git submodule update`
    end
    commit_all repo_path(repo), "updated externals"
  end
end

module Giternal
  def add_external(base, external)
    external_path = repo_path external
    Dir.chdir(repo_path(base)) do
      FileUtils.touch ".giternal.yml"
      File.open(".giternal.yml", 'w') do |f|
        f << external << ":\n"
        f << "  repo: #{external_path}\n"
        f << "  path: ."
      end
      `echo #{external} >> .gitignore`
    end
    commit_all repo_path(base), "added #{external}"
  end

  def update_externals(base)
    Dir.chdir(repo_path(base)) { puts `giternal update` }
  end
end

module Braid
  def add_external(base, external)
    external_path = repo_path external
    Dir.chdir(repo_path(base)) { puts `braid add --type git #{external_path} #{external}` }
  end

  def update_externals(base)
    Dir.chdir(repo_path(base)) { puts `braid update` }
  end
end


drivers = {"submodules" => GitSubmodules, "giternal" => Giternal, "braid" => Braid}
unless drivers.keys.include?(ARGV.first)
  puts "Run with:  ruby test_tracking.rb #{drivers.keys.join('|')}"
  exit
end
include drivers[ARGV.first]

FileUtils.rm_rf repo_path("")

def ALERT(message)
  puts
  puts "*** " + message
end

ALERT "the project has will_paginate as an external"
create_repo "will_paginate-full"
clone_repo "will_paginate-full", "will_paginate", "--bare"

create_repo "base-full"
add_external "base-full", "will_paginate"
clone_repo "base-full", "base", "--bare"

ALERT "Joe and Sarah clone copies of the project"
clone_repo "base", "joe"
update_externals "joe"

clone_repo "base", "sarah"
update_externals "sarah"

ALERT "Joe adds README to will_paginate and commits"
add_content_to "joe/will_paginate/README", "some content"

ALERT "Joe commits a change to the base project"
add_content_to "joe/foo", "in the base project"

ALERT "Joe pushes his code"
push "joe"
push "joe/will_paginate"

ALERT "Sarah adds LICENSE to her repo and commits"
add_content_to "sarah/will_paginate/LICENSE", "gnu baby"

ALERT "Sarah commits a change to the base project"
add_content_to "sarah/bar", "in the base project"

ALERT "Sarah pulls from base project and updates externals"
pull "sarah"
update_externals "sarah"
push "sarah/will_paginate"

ALERT "Does the cloned project have all the files we expect?"
verify_repo_has_files("sarah", "foo", "bar", "will_paginate/README", "will_paginate/LICENSE")

ALERT "Does the upstream external have all the files we expect?"
clone_repo "will_paginate", "will_paginate_clone"
verify_repo_has_files "will_paginate_clone", "README", "LICENSE"
puts "woooo!  Collaboration ftw"
