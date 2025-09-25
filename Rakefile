# frozen_string_literal: true

require "bundler/gem_tasks"

begin
  require "rubocop/rake_task"
  RuboCop::RakeTask.new
  task default: :rubocop
rescue LoadError
  # RuboCop not available, skip linting tasks
  puts "RuboCop not available. Install it with 'bundle install' to enable linting tasks."
  task default: []
end
