class CreateCertifications < ActiveRecord::Migration[8.1]
  def change
    create_table :certifications do |t|
      t.string :name_pt
      t.string :name_en
      t.string :provider
      t.date :certified_at
      t.string :url
      t.integer :position

      t.timestamps
    end
  end
end
