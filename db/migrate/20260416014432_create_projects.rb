class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description_pt
      t.text :description_en
      t.date :started_at
      t.date :ended_at
      t.json :technologies
      t.string :url
      t.string :github_url
      t.integer :position

      t.timestamps
    end
  end
end
