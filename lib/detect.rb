# Detect application and framework
class Detect
  attr_reader :language, :framework, :path

  def initialize(path)
    @path = path
    entries = Dir.entries(path)

    if entries.include?('Gemfile')
      @language = :ruby
      content = File.read(File.join(path, 'Gemfile'))

      if content.include?('rails')
        @framework = :rails
      end
    end
  end
end
