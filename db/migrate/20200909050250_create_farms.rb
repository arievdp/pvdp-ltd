class CreateFarms < ActiveRecord::Migration[6.0]
  def change
    create_table :farms do |t|
      t.string :code
      t.string :nickname
      t.string :address

      t.timestamps
    end
  end
end
