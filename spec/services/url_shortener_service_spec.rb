# frozen_string_literal: true

# spec/services/url_shortener_service_spec.rb
require 'rails_helper'

RSpec.describe UrlShortenerService, type: :service do
  let(:original_url) { 'https://example.com' }
  let(:service) { UrlShortenerService.new(original_url: original_url) }

  describe '#initialize' do
    it 'sets the original_url attribute' do
      expect(service.original_url).to eq(original_url)
    end
  end

  describe '#call' do
    it 'creates a URL with a unique short code and returns success' do
      result = service.call

      expect(result[:success]).to be true
      expect(result[:url]).to be_persisted
      expect(result[:url].original_url).to eq(original_url)
      expect(result[:url].short_code).not_to be_nil
    end

    it 'returns an error if the URL fails to save' do
      invalid_service = UrlShortenerService.new(original_url: '')

      result = invalid_service.call
      expect(result[:success]).to be false
      expect(result[:errors]).to include("Validation failed: Original url can't be blank, Original url is invalid")
    end

    it 'enqueues the FetchTitleJob if URL is persisted' do
      allow(FetchTitleJob).to receive(:perform_later)

      result = service.call

      expect(result[:success]).to be true
      expect(FetchTitleJob).to have_received(:perform_later).with(result[:url].id)
    end
  end

  describe '#generate_unique_short_code' do
    it 'calls BijectiveEncoder to generate a short code based on the URL id' do
      result = service.call
      short_code = BijectiveEncoder.bijective_encode(result[:url].id)

      expect(result[:url].short_code).to eq(short_code)
    end
  end
end
