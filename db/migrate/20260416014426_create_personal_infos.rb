class CreatePersonalInfos < ActiveRecord::Migration[8.1]
  def change
    create_table :personal_infos do |t|
      t.string :name
      t.string :title
      t.string :location
      t.string :email
      t.string :phone
      t.text :whatsapp_message
      t.json :bio_pt
      t.json :bio_en
      t.text :footer_text_pt
      t.text :footer_text_en

      t.timestamps
    end
  end
end
