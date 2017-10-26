module Helpers
  RAILS_REPO = 'https://gitlab.com/dzaporozhets/sast-sample-rails.git'.freeze

  def ensure_test_repo
    `git clone #{RAILS_REPO} #{tmp_app_path}` unless Dir.exist?(tmp_app_path)
  end

  def tmp_app_path
    File.join(File.expand_path(File.dirname(__FILE__)), '../tmp/rails-app')
  end
end
