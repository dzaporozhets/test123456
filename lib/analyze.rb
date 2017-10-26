require_relative 'analyzers/brakeman'
require_relative 'analyzers/bundle_audit'
require_relative 'analyzers/retire'

# Run static analyze tool over source code
class Analyze
  attr_reader :app, :issues

  def initialize(app)
    @app = app
  end

  def issues
    issues = []

    case app.language
    when :ruby
      issues += Analyzers::BundleAudit.new(app).execute

      case app.framework
      when :rails
        issues += Analyzers::Brakeman.new(app).execute
      end
    when :js
      issues += Analyzers::Retire.new(app).execute
    else
      not_supported
    end

    issues.compact
  end

  private

  def not_supported
    puts 'Source code language/framework is not yet supported for analyze'
    exit 1
  end
end
