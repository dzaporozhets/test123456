require 'json'

class Report
  attr_reader :issues

  def initialize(issues)
    @issues = issues
  end

  def save_as(target_path)
    File.write(target_path, dump)
    puts "SUCCESS: Report saved in #{target_path}"
  end

  def dump
    @issues.map(&:to_hash).to_json
  end
end
