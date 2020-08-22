begin
  require "bundler/setup"
rescue LoadError => _e
  puts("You must `gem install bundler` and `bundle install` to run rake tasks")
end

require "rdoc/task"

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title    = "EasyPg"
  rdoc.options << "--line-numbers"
  rdoc.rdoc_files.include("README.md")
  rdoc.rdoc_files.include("lib/**/*.rb")
end

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.pattern = "test/**/*_test.rb"
  t.verbose = false
  # t.test_files = FileList["test/**/*_test.rb"]
end

task(default: :test)
