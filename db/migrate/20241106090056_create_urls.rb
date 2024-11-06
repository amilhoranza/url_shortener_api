class CreateUrls < ActiveRecord::Migration[7.1]
  def change
    create_table :urls do |t|
      t.string :original_url
      t.string :short_code
      t.string :title
      t.integer :access_count, default: 0

      t.timestamps
    end
    add_index :urls, :short_code
  end
end
