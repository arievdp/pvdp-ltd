class CreateEmployments < ActiveRecord::Migration[6.0]
  def change
    create_table :employments do |t|
      t.references :farm, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
