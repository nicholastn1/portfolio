class CreateLanguages < ActiveRecord::Migration[8.1]
  def change
    create_table :languages do |t|
      t.string :name_pt
      t.string :name_en
      t.string :level_pt
      t.string :level_en
      t.string :proficiency
      t.integer :position

      t.timestamps
    end
  end
end
