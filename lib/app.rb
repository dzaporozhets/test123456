class App
  attr_reader :language, :framework, :path

  def initialize(path)
    @path = File.expand_path(path)
    entries = Dir.entries(path)

    if entries.include?('Gemfile')
      @language = :ruby

      if entries.include?('Gemfile.lock')
        content = File.read(File.join(path, 'Gemfile.lock'))

        if content.include?(' rails ')
          @framework = :rails
        end
      end
    elsif entries.include?('package.json')
      @language = :js
    end
  end
end
