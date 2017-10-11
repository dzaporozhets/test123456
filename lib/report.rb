require 'json'

# Build a JSON report based on static analysis
# Report structure must be next:
#
# {
#   "tool":"brakeman",
#   "warnings":[
#     {
#       "fingerprint":"715ad9c0d76f57a6a657192574d528b620176a80fec969e2f63c88eacab0b984",
#       "message":"Session secret should not be included in version control",
#       "file":"config/initializers/secret_token.rb",
#       "line":12,
#       "link":"http://brakemanscanner.org/docs/warning_types/session_setting/",
#       "confidence":"High",
#       "cve_id":null
#     }
#   ]
# }
#
class Report
  attr_reader :result, :report

  def initialize(result)
    @result = result
    @report = build_report
  end

  def build_report
    case @result.output_format
    when :brakeman
      parse_brakeman(@result.output)
    else
      raise "Report parsing for #{@result.output_format} is not supported"
    end
  end

  def save_as(target_path)
    File.write(target_path, @report.to_json)
    puts "SUCCESS: Report saved in #{target_path}"
  end

  def parse_brakeman(output)
    report = {}
    report[:tool] = :brakeman
    report[:warnings] = []

    output['warnings'].each do |warning|
      report[:warnings] << {
        fingerprint: warning['fingerprint'],
        message: warning['message'],
        file: warning['file'],
        line: warning['line'],
        link: warning['link'],
        confidence: warning['confidence'],
        cve_id: nil
      }
    end

    report
  end
end
