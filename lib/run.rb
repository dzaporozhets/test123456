require_relative 'app'
require_relative 'analyze'
require_relative 'report'

class Run
  def initialize(path)
    app = App.new(path)
    issues = Analyze.new(app).issues
    report = Report.new(issues)
    report.save_as(File.join(path, 'gl-sast-report.json'))
  end
end
