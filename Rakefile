# frozen_string_literal: true

require "rake"
require "bundler/gem_tasks"
require "standard/rake"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  # t.test_files = FileList('test/**/*_test.rb')
  t.pattern = 'test/**/*_test.rb'
end

task default: :standard
