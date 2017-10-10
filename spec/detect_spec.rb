require_relative '../lib/detect'
require 'spec_helper'

describe Detect do
  before do
    unless Dir.exist?(tmp_app)
      `git clone git@gitlab.com:dzaporozhets/sample-rails-app.git #{tmp_app}`
    end
  end

  let(:tmp_app) { File.join(File.expand_path(File.dirname(__FILE__)), '../tmp/rails-app') }
  let(:app) { Detect.new(tmp_app) }

  it { expect(app.language).to eq(:ruby) }
  it { expect(app.framework).to eq(:rails) }
end
