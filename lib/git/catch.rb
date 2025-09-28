require "yaml"
require "logger"
require "fileutils"

module Git
  module Catch
    class Runner

      def initialize
        @logger = Logger.new(STDOUT)
        @logger.formatter = proc do |type, time, name, message|
          "[#{time}]  #{type.ljust(5)}  #{message}\n"
        end

        @config = YAML.load_file("./.git-catch.yaml")
        @hooks_dir = @config.fetch("hooks_dir", nil)
        @hooks_names  = [
          "applypatch-msg",
          "commit-msg",
          "post-update",
          "pre-applypatch",
          "pre-commit",
          "pre-push",
          "pre-rebase",
          "prepare-commit-msg",
          "update",
        ]
      end

      def init
        @config.fetch("hooks", {}).each do |name, _|
          if !@hooks_names.include? name
            @logger.error "Hook #{name} is not known."
            next
          end
          build name, files(name)
        end
      end

      def list
        data = {}
        @config.fetch("hooks", {}).each do |name, _|
          if !@hooks_names.include? name
            @logger.error "Hook #{name} is not known."
            next
          end

          data[name] = files(name)
        end

        data
      end

      private
      def files(name)
        files = @config.fetch("extra_hooks", {}).fetch(name, [])
        files = (files + dir_files(@dir, name)).uniq if @dir
        files
      end

      def build(name, files)
        file = ".git/hooks/#{name}"
        content = <<~EOS
          #!/usr/bin/env bash
          set -euo pipefail

        EOS
        files.each do |file|
          content << "#{file}\n"
        end
        File.write file, content
        FileUtils.chmod "+x", file
        @logger.info "File #{file} written"
      end

      def dir_files(hooks_dir, hook_name)
        files = []
        Dir["#{hooks_dir}/#{hook_name}/**/*"].each do |f|
          if not File.executable? f
            @logger.warn "File #{f} is not executable"
            next
          end
          files << f
        end
        files
      end

    end
  end
end
