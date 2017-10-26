require_relative 'app'
require_relative 'analyze'
require_relative 'report'

# Detect application and analyze
class Run
  def initialize(path)
    app = App.new(path)
    issues = Analyze.new(app).issues
    report = Report.new(issues)
    report.save_as(File.join(path, 'gl-sast-report.json'))
  end
end
