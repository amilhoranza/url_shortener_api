class Url < ApplicationRecord
  validates :original_url, presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
  validates :short_code, uniqueness: true
end
