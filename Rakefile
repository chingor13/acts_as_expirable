require 'rake'
require 'rake/testtask'

desc 'Default: run acts_as_expirable unit tests.'
task :default => :test

desc 'Test the acts_as_expirable plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
