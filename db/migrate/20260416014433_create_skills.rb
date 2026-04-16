class CreateSkills < ActiveRecord::Migration[8.1]
  def change
    create_table :skills do |t|
      t.string :name
      t.string :category
      t.string :proficiency
      t.boolean :featured
      t.integer :position

      t.timestamps
    end
  end
end
