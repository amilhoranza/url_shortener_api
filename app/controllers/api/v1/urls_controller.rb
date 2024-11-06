# frozen_string_literal: true

module Api
  module V1
    # URLs controller API responsible for shortened urls creation
    class UrlsController < ApplicationController
      def create
        service = UrlShortenerService.new(original_url: params[:original_url])
        result = service.call

        if result[:success]
          url = result[:url]
          short_url = "#{request.base_url}/#{url.short_code}"
          render json: { short_url: short_url }, status: :created
        else
          render json: { errors: result[:errors] }, status: :unprocessable_entity
        end
      end

      def top
        top_urls = Url.order(access_count: :desc).limit(100)
        render json: top_urls.as_json(only: %i[short_code original_url title access_count])
      end
    end
  end
end
