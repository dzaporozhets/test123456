# Collect information about source code like programming language and framework
class App
  attr_reader :language, :framework, :path

  def initialize(path)
    @path = File.expand_path(path)
    @language = detect_language
    @framework = detect_framework
  end

  private

  def detect_language
    if files.include?('Gemfile')
      :ruby
    elsif files.include?('package.json')
      :js
    end
  end

  def detect_framework
    case language
    when :ruby
      if files.include?('Gemfile.lock')
        content = File.read(File.join(path, 'Gemfile.lock'))

        :rails if content.include?(' rails ')
      end
    end
  end

  def files
    @files ||= Dir.entries(path)
  end
end
