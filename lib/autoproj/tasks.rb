# frozen_string_literal: true

require_relative "tasks/version"
require_relative "tasks/task_resolver"

module Autoproj
  module Tasks
    class Error < StandardError; end
  end
end
