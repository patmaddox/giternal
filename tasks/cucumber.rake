begin
  require 'cucumber/rake/task'

  Cucumber::Rake::Task.new do |t|
    t.cucumber_opts = "--format pretty"
  end

rescue LoadError
  at_exit do
    puts <<-EOS

**********************************************************
To use cucumber for testing you must install cucumber gem:
      http://github.com/aslakhellesoy/cucumber/tree/master
    EOS
  end
end
