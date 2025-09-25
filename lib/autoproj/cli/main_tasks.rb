# frozen_string_literal: true

require "thor"
require "autoproj/tasks"

module Autoproj
  module CLI
    # CLI interface for autoproj tasks subcommand
    class MainTasks < Thor
      desc "TASK_NAME", "execute a named task with arguments"
      def execute(task_name = nil, *args)
        if task_name.nil?
          puts "Error: No task name provided"
          puts "Usage: autoproj tasks TASK_NAME [args...]"
          puts "Example: autoproj tasks sipacc:deploy --package sipacc_control --host sipacc_crawler_sbc"
          exit 1
        end

        task_resolver = Autoproj::Tasks::TaskResolver.new
        
        begin
          command = task_resolver.resolve_task(task_name, args)
          puts "Executing: #{command}"
          
          system(command)
          exit_code = $?.exitstatus
          exit exit_code unless exit_code == 0
        rescue Autoproj::Tasks::TaskNotFoundError => e
          puts "Error: #{e.message}"
          exit 1
        rescue => e
          puts "Error executing task: #{e.message}"
          exit 1
        end
      end

      default_task :execute

      desc "list", "list all available tasks"
      def list
        task_resolver = Autoproj::Tasks::TaskResolver.new
        tasks = task_resolver.list_tasks
        
        if tasks.empty?
          puts "No tasks configured"
        else
          puts "Available tasks:"
          tasks.each do |namespace, task_list|
            task_list.each do |task_name, command|
              puts "  #{namespace}:#{task_name}"
            end
          end
        end
      end
    end
  end
end