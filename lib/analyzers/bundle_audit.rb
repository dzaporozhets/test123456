require_relative 'helpers'
require_relative '../issue'

module Analyzers
  class BundleAudit
    include Analyzers::Helpers

    def initialize(app)
      @app = app
    end

    def execute
      puts 'Installing Ruby dependency scan tool (bundler-audit)'

      Dir.chdir(@app.path) do
        if cmd("gem install bundler-audit")
          puts ' - bundle audit'
          result = parse_output(`bundle audit`)
          puts result
          result.map do |item|
            issue = Issue.new
            issue.tool = :bundler_audit
            issue.message = item[:message]
            issue.url = item[:url]
            issue.cve = item[:cve]
            issue.file = 'Gemfile.lock'
            issue.solution = item[:solution]
            issue
          end
        else
          []
        end
      end
    end

    def parse_output(output)
      output.split(/\n\n/).map do |record|
        if record.start_with?('Name: ')
          lines = record.split(/\n/)
          item = {}

          lines.each do |line|
            if line.start_with?('Title: ')
              item[:message] = line.sub('Title: ', '')
            elsif line.start_with?('Advisory: ')
              item[:cve] = line.sub('Advisory: ', '')
            elsif line.start_with?('Solution: ')
              item[:solution] = line.sub('Solution: ', '')
            elsif line.start_with?('URL: ')
              item[:url] = line.sub('URL: ', '')
            end
          end

          item
        end
      end.compact
    end
  end
end
