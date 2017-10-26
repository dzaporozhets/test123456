require 'json'
require "tmpdir"

require_relative 'helpers'
require_relative '../issue'

module Analyzers
  class Retire
    include Analyzers::Helpers

    BUILDPACK_URL = 'https://github.com/heroku/heroku-buildpack-nodejs'

    attr_reader :app, :report_path

    def initialize(app)
      @app = app
      @report_path = File.join(@app.path, 'retire-result.json')
    end

    def execute
      prepare

      output = nil

      Dir.chdir(@app.path) do
        cmd <<-SH
          export NODE_HOME="#{@app.path}/.heroku/node"
          export PATH="#{@app.path}/.heroku/node/bin:#{@app.path}/.heroku/yarn/bin:$PATH:#{@app.path}/bin:#{@app.path}/node_modules/.bin"
          npm install -g retire
          retire --outputformat json --outputpath #{report_path}
        SH

        output = JSON.parse(File.read(report_path))

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

    def prepare
      Dir.mktmpdir do |dir|
        unless cmd("git clone #{BUILDPACK_URL} #{dir}") &&
            cmd("#{dir}/bin/test-compile #{@app.path}")
          puts 'Failed to prepare environment'
          exit 1
        end
      end
    end
  end
end
