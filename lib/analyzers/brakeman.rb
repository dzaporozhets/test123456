require 'json'
require "tmpdir"

require_relative 'helpers'
require_relative '../issue'

module Analyzers
  class Brakeman
    include Analyzers::Helpers

    def initialize(app)
      @app = app
    end

    def execute
      puts 'Installing Rails scan tool (brakeman)'

      Dir.chdir(@app.path) do
        Dir.mktmpdir do |dir|
          if cmd("gem install brakeman")
            cmd("brakeman -w3 -o #{dir}/brakeman.json")
            output = JSON.parse(File.read("#{dir}/brakeman.json"))

            output['warnings'].map do |warning|
              issue = Issue.new
              issue.tool = :brakeman
              issue.fingerprint = warning['fingerprint']
              issue.message = warning['message']
              issue.url = warning['link']
              issue.file = warning['file']
              issue.line = warning['line']
              issue.priority = warning['confidence']
              issue
            end
          else
            []
          end
        end
      end
    end
  end
end
