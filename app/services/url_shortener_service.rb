# frozen_string_literal: true

# app/services/url_shortener_service.rb
class UrlShortenerService
  attr_reader :original_url, :fetch_title_job

  def initialize(original_url:, fetch_title_job: FetchTitleJob)
    @original_url = original_url
    @fetch_title_job = fetch_title_job
  end

  def call
    validate_params!

    url = create_url_with_short_code
    if url.persisted?
      enqueue_title_job(url)
      { success: true, url: url }
    else
      { success: false, errors: url.errors.full_messages }
    end
  rescue ActiveRecord::RecordInvalid => e
    { success: false, errors: [e.message] }
  end

  private

  def validate_params!
    { success: false, errors: ['original_url must be provided'] } if original_url.blank?
  end

  def create_url_with_short_code
    url = Url.create!(original_url: original_url)
    url.update!(short_code: generate_unique_short_code(url.id))
    url
  end

  def enqueue_title_job(url)
    fetch_title_job.perform_later(url.id)
  end

  def generate_unique_short_code(url_id)
    BijectiveEncoder.bijective_encode(url_id)
  end
end
