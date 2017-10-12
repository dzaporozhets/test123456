require_relative 'detect'
require_relative 'analyze'
require_relative 'report'

class Run
  def initialize(path)
    app = Detect.new(path)
    result = Analyze.new(app)
    report = Report.new(result)
    report.save_as(File.join(path, 'gl-sast-report.json'))
  end
end
