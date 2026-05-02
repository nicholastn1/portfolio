class AddTaglineToPersonalInfos < ActiveRecord::Migration[8.1]
  def change
    add_column :personal_infos, :tagline_pt, :text
    add_column :personal_infos, :tagline_en, :text
  end
end
