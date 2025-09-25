# frozen_string_literal: true

require "yaml"
require "pathname"

begin
  require "autoproj"
rescue LoadError
  # Autoproj not available, continue without it
end

module Autoproj
  module Tasks
    class TaskNotFoundError < StandardError; end

    # Resolves task names to commands and executes them
    class TaskResolver
      def initialize
        @config_file = find_config_file
      end

      def resolve_task(task_name, all_args = [])
        namespace, task = parse_task_name(task_name)
        
        tasks = load_tasks
        
        unless tasks.dig(namespace, task)
          available_tasks = list_available_tasks(tasks)
          raise TaskNotFoundError, 
            "Task '#{task_name}' not found. Available tasks: #{available_tasks.join(', ')}"
        end

        command_template = tasks[namespace][task]
        build_command(command_template, all_args)
      end

      def list_tasks
        load_tasks
      end

      private

      def find_config_file
        # Use Autoproj workspace config directory
        begin
          config_dir = Autoproj.workspace.config_dir
          config_file = File.join(config_dir, "autoproj-tasks.yml")
          return config_file if File.exist?(config_file)
        rescue
          # If we can't access Autoproj workspace, fall back to current directory
        end
        
        # Fallback: look in current directory
        config_file = File.join(Dir.pwd, "autoproj-tasks.yml")
        return config_file if File.exist?(config_file)
        
        nil
      end

      def load_tasks
        return {} unless @config_file && File.exist?(@config_file)

        begin
          config = YAML.load_file(@config_file)
          return {} unless config.is_a?(Hash) && config["tasks"]
          
          config["tasks"]
        rescue => e
          warn "Warning: Could not load config file #{@config_file}: #{e.message}"
          {}
        end
      end

      def parse_task_name(task_name)
        if task_name.include?(":")
          parts = task_name.split(":", 2)
          [parts[0], parts[1]]
        else
          ["default", task_name]
        end
      end

      def build_command(command_template, args)
        # Expand environment variables in the command template
        command = expand_env_vars(command_template)
        
        # Add all arguments directly to the command
        unless args.empty?
          command += " " + args.join(" ")
        end

        command.strip
      end

      def expand_env_vars(template)
        # Expand ${VAR} and $VAR style environment variables
        template.gsub(/\$\{([^}]+)\}/) do |match|
          var_name = $1
          ENV[var_name] || match
        end.gsub(/\$([A-Z_][A-Z0-9_]*)/i) do |match|
          var_name = $1
          ENV[var_name] || match
        end
      end

      def list_available_tasks(tasks)
        available = []
        tasks.each do |namespace, namespace_tasks|
          namespace_tasks.each_key do |task_name|
            available << "#{namespace}:#{task_name}"
          end
        end
        available
      end
    end
  end
end