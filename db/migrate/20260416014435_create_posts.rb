class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title_pt
      t.string :title_en
      t.text :description_pt
      t.text :description_en
      t.string :slug
      t.string :category
      t.json :tags
      t.boolean :published
      t.datetime :published_at
      t.string :locale
      t.integer :reading_time

      t.timestamps
    end
  end
end
