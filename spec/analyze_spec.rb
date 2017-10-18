require_relative '../lib/analyze'
require 'spec_helper'

RSpec.describe Analyze do
  before { ensure_test_repo }

  let(:app) { double(language: :ruby, framework: :rails, path: tmp_app_path) }

  let(:issues) do
    Bundler.with_clean_env do
      Analyze.new(app).issues
    end
  end

  let(:issue) { issues.first }

  it { expect(issues.size).to eq(1) }
  it { expect(issue.tool).to eq(:brakeman) }
  it { expect(issue.message).to eq('Possible command injection') }
end
