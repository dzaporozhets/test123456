require_relative '../lib/app'
require 'spec_helper'

RSpec.describe App do
  before { ensure_test_repo }

  let(:app) { App.new(tmp_app_path) }

  it { expect(app.language).to eq(:ruby) }
  it { expect(app.framework).to eq(:rails) }
end
