# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

# FetchTitleJob retrieves and updates the title of a URL record in the database.
class FetchTitleJob < ApplicationJob
  queue_as :default

  def perform(url_id)
    url = Url.find_by(id: url_id)
    return Rails.logger.warn("URL with ID #{url_id} not found") unless url

    title = fetch_page_title(url.original_url)
    url.update(title: title) if title
  rescue StandardError => e
    Rails.logger.error("Failed to fetch title for URL ID #{url_id}: #{e.message}")
  end

  private

  def fetch_page_title(url)
    html = OpenURI.open_uri(url)
    document = Nokogiri::HTML(html)
    document.css('title')&.text
  end
end
