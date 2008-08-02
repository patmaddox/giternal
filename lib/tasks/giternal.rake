namespace :giternal do
  desc "Clone or pull giternal repos"
  task :update do
    require "giternal"

    Giternal::App.new(FileUtils.pwd).run
  end
end
