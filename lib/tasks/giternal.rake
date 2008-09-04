def require_giternal
  if File.exist?(File.dirname(__FILE__) + '/../../lib/giternal.rb')
    $:.unshift(File.dirname(__FILE__) + '/../../lib')
  end
  require 'giternal'
end

namespace :giternal do
  desc "Clone or pull giternal repos"
  task :update do
    require_giternal

    Giternal::App.new(FileUtils.pwd).update
  end

  desc "Freeze giternal repos"
  task :freeze do
    require_giternal

    Giternal::App.new(FileUtils.pwd).freezify
  end
end
