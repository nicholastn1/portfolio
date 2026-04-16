class CreateExperiences < ActiveRecord::Migration[8.1]
  def change
    create_table :experiences do |t|
      t.string :company
      t.string :role_pt
      t.string :role_en
      t.string :company_url
      t.date :started_at
      t.date :ended_at
      t.text :description_pt
      t.text :description_en
      t.json :achievements_pt
      t.json :achievements_en
      t.json :technologies
      t.integer :position

      t.timestamps
    end
  end
end
