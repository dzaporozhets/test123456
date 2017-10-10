# Build a JSON report based on static analysis
class Report
  attr_reader :result, :report

  def initialize(result)
    @result = result
    @report = build_report
  end

  def build_report
    case @result.output_format
    when 1
    else
      raise "Report parsing for #{@result.output_format} is not supported"
    end
  end

  def save_as(target_path)
    File.write(target_path, @report)
    puts "SUCCESS: Report saved in #{target_path}"
  end
end
