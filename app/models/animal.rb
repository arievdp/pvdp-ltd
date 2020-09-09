class Animal < ApplicationRecord
  belongs_to :farm
  validates :birth_id, presence: true, uniqueness: true

  def calves
    Animal.where(dam_birth_id: birth_id)
  end
end
