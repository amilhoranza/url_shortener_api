# frozen_string_literal: true

# spec/jobs/fetch_title_job_spec.rb
require 'rails_helper'

RSpec.describe FetchTitleJob, type: :job do
  let(:url) { Url.create(original_url: 'https://www.example.com', short_code: 'abc123') }

  before do
    stub_request(:get, url.original_url).to_return(
      body: '<html><head><title>Example Title</title></head><body></body></html>',
      headers: { 'Content-Type' => 'text/html' }
    )
  end

  it 'fetches and saves the title of the URL' do
    FetchTitleJob.perform_now(url.id)
    url.reload
    expect(url.title).to eq('Example Title')
  end

  it 'logs an error if the URL is invalid' do
    invalid_url = Url.create(original_url: 'https://invalid-url.com', short_code: 'def456')
    stub_request(:get, invalid_url.original_url).to_raise(StandardError.new('Failed to open URL'))
    expect(Rails.logger).to receive(:error).with(/Failed to fetch title for URL/)
    FetchTitleJob.perform_now(invalid_url.id)
  end
end
