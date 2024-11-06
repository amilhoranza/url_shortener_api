# frozen_string_literal: true

# spec/requests/urls_spec.rb
require 'rails_helper'

RSpec.describe 'URL Shortener API', type: :request do
  describe 'POST /api/v1/urls' do
    it 'creates a short URL and generates a title' do
      WebMock.allow_net_connect!

      post '/api/v1/urls', params: { original_url: 'https://www.example.com' }

      expect(response).to have_http_status(:created)
      response_data = JSON.parse(response.body)
      expect(response_data).to have_key('short_url')

      short_code = response_data['short_url'].split('/').last
      url = Url.find_by(short_code: short_code)

      FetchTitleJob.perform_now(url.id)

      url.reload
      expect(url.title).not_to be_nil
      expect(url.title).to be_a(String)
    end
  end

  describe 'GET /api/v1/top_urls' do
    it 'returns top 100 most accessed URLs' do
      get '/api/v1/top_urls'
      expect(response).to have_http_status(:ok)
    end
  end
end
