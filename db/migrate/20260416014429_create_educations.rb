class CreateEducations < ActiveRecord::Migration[8.1]
  def change
    create_table :educations do |t|
      t.string :institution
      t.string :degree_pt
      t.string :degree_en
      t.string :course_pt
      t.string :course_en
      t.date :started_at
      t.date :ended_at
      t.json :activities_pt
      t.json :activities_en
      t.integer :position

      t.timestamps
    end
  end
end
