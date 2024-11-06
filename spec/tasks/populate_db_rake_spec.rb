# frozen_string_literal: true

# spec/tasks/populate_db_rake_spec.rb
require 'rails_helper'
require 'rake'

RSpec.describe 'db:populate_urls', type: :task do
  before :all do
    Rake.application.rake_require('tasks/populate_db')
    Rake::Task.define_task(:environment)
  end

  it 'populates the database with 100 URLs with unique short codes and titles' do
    expect { Rake::Task['db:populate_urls'].invoke }.to change { Url.count }.by(100)

    urls = Url.all
    expect(urls.pluck(:title).compact.size).to eq(100)
    expect(urls.pluck(:short_code).uniq.size).to eq(100)

    Rake::Task['db:populate_urls'].reenable
  end
end
