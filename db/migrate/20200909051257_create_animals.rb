class CreateAnimals < ActiveRecord::Migration[6.0]
  def change
    create_table :animals do |t|
      t.references :farm, null: false, foreign_key: true
      t.string :birth_id
      t.string :tag_number
      t.string :birth_date
      t.string :bw_value
      t.string :bw_reliability
      t.string :pw_value
      t.string :pw_reliability
      t.string :a2_status
      t.string :expected_calving_date
      t.string :calving_date
      t.string :dam_id
      t.string :dam_tag_number
      t.string :sire_id
      t.string :sire_name
      t.string :sex
      t.string :fate

      t.timestamps
    end
  end
end
