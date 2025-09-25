# frozen_string_literal: true

require "autoproj/cli/main_tasks"

class Autoproj::CLI::Main
    desc "tasks", "execute and manage custom tasks"
    subcommand "tasks", Autoproj::CLI::MainTasks
end