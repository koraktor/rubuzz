# This code is free software; you can redistribute it and/or modify it under the
# terms of the new BSD License.
#
# Copyright (c) 2010, Sebastian Staudt

require 'rake/rdoctask'
require 'rake/testtask'

src_files = Dir.glob(File.join('lib', '**', '*.rb'))
test_files = Dir.glob(File.join('test', '**', '*.rb'))

task :default => :test

# Test task
Rake::TestTask.new do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/**/*_tests.rb'
  t.verbose = true
end

begin
  require 'jeweler'
  # Gem specification
  Jeweler::Tasks.new do |gem|
    gem.authors = ['Sebastian Staudt']
    gem.email = 'koraktor@gmail.com'
    gem.description = 'A Ruby client library for Google Buzz'
    gem.date = Time.now
    gem.homepage = 'http://koraktor.github.com/rubuzz'
    gem.name = gem.rubyforge_project = 'rubuzz'
    gem.summary = 'Rubuzz - Access Google Buzz'

    gem.files = %w(README.md Rakefile LICENSE VERSION.yml) + src_files + test_files
    gem.rdoc_options = ['--all', '--inline-source', '--line-numbers', '--charset=utf-8', '--webcvs=http://github.com/koraktor/rubuzz/blob/master/%s']
  end
rescue LoadError
  puts "You need Jeweler to build the gem. Install it using `gem install jeweler`."
end

# Create a rake task +:rdoc+ to build the documentation
desc 'Building docs'
Rake::RDocTask.new do |rdoc|
  rdoc.title = 'Rubuzz - API documentation'
  rdoc.rdoc_files.include ['lib/**/*.rb', 'LICENSE', 'README.md']
  rdoc.main = 'README.md'
  rdoc.rdoc_dir = 'doc'
  rdoc.options = ['--all', '--inline-source', '--line-numbers', '--charset=utf-8', '--webcvs=http://github.com/koraktor/rubuzz/blob/master/%s']
end

# Task for cleaning documentation and package directories
desc 'Clean documentation and package directories'
task :clean do
  FileUtils.rm_rf 'doc'
  FileUtils.rm_rf 'pkg'
end
