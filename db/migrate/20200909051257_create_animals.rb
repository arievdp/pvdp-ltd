class CreateAnimals < ActiveRecord::Migration[6.0]
  def change
    create_table :animals do |t|
      t.references :farm, null: false, foreign_key: true
      t.string :birth_id
      t.integer :cow_number
      t.string :birth_date
      t.integer :bw_value
      t.integer :bw_reliability
      t.integer :pw_value
      t.integer :pw_reliability
      t.string :a2_status
      t.string :sex
      t.string :fate
      t.string :expected_calving_date
      t.string :calving_date
      t.string :calf_birth_id
      t.string :calf_birth_date
      t.string :calf_sex
      t.string :calf_fate
      t.string :dam_birth_id
      t.integer :dam_cow_number
      t.string :sire_birth_id
      t.string :sire_name
      t.timestamps
    end
  end
end
