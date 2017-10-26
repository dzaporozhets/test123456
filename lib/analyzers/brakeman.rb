require 'json'
require 'tmpdir'

require_relative 'helpers'
require_relative '../issue'

module Analyzers
  # Language: Ruby
  # Framework: Rails
  # A static analysis security vulnerability scanner
  class Brakeman
    include Analyzers::Helpers

    REPORT_NAME = 'gl-sast-brakeman.json'.freeze

    attr_reader :app, :report_path

    def initialize(app)
      @app = app
      @report_path = File.join(@app.path, REPORT_NAME)
    end

    def execute
      output = analyze
      output_to_issues(output)
    end

    private

    def analyze
      Dir.chdir(@app.path) do
        cmd <<-SH
          gem install brakeman
          brakeman -w3 -o #{report_path}
        SH

        JSON.parse(File.read(report_path))
      end
    ensure
      File.delete(report_path) if File.exist?(report_path)
    end

    def output_to_issues(output)
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
    end
  end
end
