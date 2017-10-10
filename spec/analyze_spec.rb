require_relative '../lib/analyze'
require 'spec_helper'

RSpec.describe Analyze do
  before { ensure_test_repo }

  let(:app) { double(language: :ruby, framework: :rails, path: tmp_app_path) }
  let(:result) { Analyze.new(app) }

  it { expect(result.output_format).to eq(:brakeman) }
end
