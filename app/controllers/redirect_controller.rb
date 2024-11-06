# frozen_string_literal: true

# Responsible for the urls redirection
class RedirectController < ApplicationController
  def show
    url = Url.find_by(short_code: params[:short_code])

    if url
      url.increment!(:access_count)
      script = "<script>alert('You are being redirected to #{url.original_url}');window.location='#{url.original_url}';</script>"
      render html: script.html_safe, status: :moved_permanently
    else
      script = "<script>alert('URL not found.');window.history.back();</script>"
      render html: script.html_safe, status: :not_found
    end
  end
end
