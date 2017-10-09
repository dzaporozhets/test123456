require_relative 'detect'
require_relative 'analyze'
require_relative 'report'

class Run
  def initialize
    app = Detect.new

    if app.supported?
      result = Analyze.new(app)
      report = Report.new(result)
      report.save_as('/tmp/gl-sast-report.json')
    end
  end
end
