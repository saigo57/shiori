# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'url_add_params' do
    it { expect(add_params_to_url('/test', { a: 100 })).to eq '/test?a=100' }
    it { expect(add_params_to_url('/test?a=100', { b: 200 })).to eq '/test?a=100&b=200' }
    it { expect(add_params_to_url('/test?a=100', { a: 300 })).to eq '/test?a=300' }
    it { expect(add_params_to_url('/test?a=100', {})).to eq '/test?a=100' }
    it { expect(add_params_to_url('/test', {})).to eq '/test' }
    it { expect(add_params_to_url('/test', nil)).to eq '/test' }
  end
end
