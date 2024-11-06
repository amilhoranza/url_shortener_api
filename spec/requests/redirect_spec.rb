# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RedirectController, type: :controller do
  describe 'GET #show' do
    context 'when the short URL exists' do
      let(:url) { Url.create(original_url: 'https://example.com', short_code: 'abc123') }

      it 'displays a JavaScript alert with the redirect message and returns a 301 status' do
        get :show, params: { short_code: url.short_code }

        expect(response.body).to include("alert('You are being redirected to #{url.original_url}');")
        expect(response.body).to include("window.location='#{url.original_url}';")
        expect(response).to have_http_status(:moved_permanently)
      end

      it 'increments the access_count counter' do
        expect { get :show, params: { short_code: url.short_code } }
          .to change { url.reload.access_count }.by(1)
      end
    end

    context 'when the short URL does not exist' do
      it 'displays a JavaScript alert indicating that the URL was not found and returns a 404 status' do
        get :show, params: { short_code: 'nonexistent' }

        expect(response.body).to include("alert('URL not found.');")
        expect(response.body).to include('window.history.back();')
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
