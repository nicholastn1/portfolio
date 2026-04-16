class CreateVolunteerings < ActiveRecord::Migration[8.1]
  def change
    create_table :volunteerings do |t|
      t.string :role_pt
      t.string :role_en
      t.string :organization
      t.date :started_at
      t.date :ended_at
      t.integer :position

      t.timestamps
    end
  end
end
