require_relative '../lib/detect'
require 'spec_helper'

RSpec.describe Detect do
  before { ensure_test_repo }

  let(:app) { Detect.new(tmp_app_path) }

  it { expect(app.language).to eq(:ruby) }
  it { expect(app.framework).to eq(:rails) }
end
