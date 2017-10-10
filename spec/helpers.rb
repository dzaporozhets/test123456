module Helpers
  def ensure_test_repo
    unless Dir.exist?(tmp_app_path)
      `git clone git@gitlab.com:dzaporozhets/sample-rails-app.git #{tmp_app_path}`
    end
  end

  def tmp_app_path
    File.join(File.expand_path(File.dirname(__FILE__)), '../tmp/rails-app')
  end
end
