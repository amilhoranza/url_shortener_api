# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  it 'is valid with a valid original URL' do
    url = Url.new(original_url: 'https://example.com')
    expect(url).to be_valid
  end

  it 'increments access_count on redirect' do
    url = Url.create(original_url: 'https://example.com', short_code: 'test123')
    expect { url.increment!(:access_count) }.to change { url.access_count }.by(1)
  end
end
