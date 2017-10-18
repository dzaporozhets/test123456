require_relative 'helpers'
require_relative '../issue'
require 'pry'
module Analyzers
  class Retire
    include Analyzers::Helpers

    def initialize(app)
      @app = app
    end

    def execute
      output = nil

      Dir.chdir(@app.path) do
        cmd('retire --outputformat json --outputpath retire-result.json')
        output = JSON.parse(File.read(File.join(@app.path, 'retire-result.json')))

        raise 'Retire.js scan failed' if output.empty?
      end

      issues = []

      output.each do |record|
        filename = record.fetch('file', nil)

        record['results'].each do |result|
          puts ' x ' + result.inspect
          if result['vulnerabilities']
            result['vulnerabilities'].each do |vulnerability|
              issue = Issue.new
              issue.tool = :retire
              issue.url = vulnerability['info'].first

              if filename
                issue.file = filename
              end

              issue.priority = vulnerability['severity']

              if identifiers = vulnerability['identifiers']
                if identifiers['CVE']
                  issue.cve = identifiers['CVE'].first
                end
                issue.message = identifiers['summary']
              end

              issues << issue
            end
          end
        end
      end

      issues
    end
  end
end
