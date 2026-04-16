class CreateSocialLinks < ActiveRecord::Migration[8.1]
  def change
    create_table :social_links do |t|
      t.references :personal_info, null: false, foreign_key: true
      t.string :platform
      t.string :url
      t.string :label
      t.string :icon
      t.integer :position

      t.timestamps
    end
  end
end
