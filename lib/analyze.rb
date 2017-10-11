# Run static analyze tool over source code
require "tmpdir"
require 'json'

class Analyze
  attr_reader :app, :output, :output_format

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

    Dir.chdir(@app.path) do
      Dir.mktmpdir do |dir|
        if cmd("gem install brakeman")
          cmd("brakeman -w3 -o #{dir}/brakeman.json")
          @output_format = :brakeman
          @output = JSON.parse(File.read("#{dir}/brakeman.json"))
        end
      end
    end
  end

  def cmd(cmd)
    puts ' - ' + cmd
    system(cmd)
  end
end
