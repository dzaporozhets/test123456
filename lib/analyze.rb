# Run static analyze tool over source code
class Analyze
  attr_reader :app, :output

  def initialize(app)
    @app = app

    case app.language
    when :ruby
      case app.framework
      when :rails
        brakeman
      else
        not_supported
      end
    else
      not_supported
    end
  end

  def not_supported
    puts 'Source code language/framework is not yet supported for analyze'
    exit 1
  end

  def brakeman
    puts 'Installing Rails scan tool (brakeman)'
    cmd('gem install brakeman')

    Dir.chdir(@app.path) do
      cmd("brakeman -w3 -o /tmp/gl-brakeman.json")
    end

    @output = File.read('/tmp/gl-brakeman.json')
  end

  def cmd(cmd)
    # Use `` execution for now for easier debug
    puts ' - ' + cmd
    `#{cmd}`
  end
end
