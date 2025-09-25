# frozen_string_literal: true

require_relative "lib/autoproj/tasks/version"

Gem::Specification.new do |spec|
  spec.name = "autoproj-tasks"
  spec.version = Autoproj::Tasks::VERSION
  spec.authors = ["caioaamaral"]
  spec.email = ["caioaamaral@gmail.com"]

  spec.summary = "Autoproj plugin for custom task management and execution"
  spec.description = "Add custom task management capabilities to autoproj with namespaced commands"
  spec.homepage = "https://github.com/caioaamaral/autoproj-tasks"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host' to allow pushing to a single host or delete this
  # section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/caioaamaral/autoproj-tasks"
  spec.metadata["changelog_uri"] = "https://github.com/caioaamaral/autoproj-tasks/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "autoproj", "~> 2.18"
  spec.add_dependency "thor", "~> 1.0"

  # Development dependencies
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", ">= 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
