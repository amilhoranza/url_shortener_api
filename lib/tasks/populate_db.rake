# frozen_string_literal: true

# lib/tasks/populate_db.rake
namespace :db do
  desc 'Populate the database with fake URLs'
  task populate_urls: :environment do
    require 'securerandom'
    require 'faker'

    100.times do
      original_url = Faker::Internet.url
      title = Faker::Book.title
      short_code = nil

      loop do
        short_code = BijectiveEncoder.bijective_encode(rand(1..1000))
        break unless Url.exists?(short_code: short_code)
      end

      Url.create!(
        original_url: original_url,
        short_code: short_code,
        title: title,
        access_count: rand(1..100)
      )
    end

    puts 'Database populated with 100 fake URLs'
  end
end
