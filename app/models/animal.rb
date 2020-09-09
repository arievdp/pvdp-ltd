class Animal < ApplicationRecord
  belongs_to :farm
  validates :birth_id, prescence: true, uniqueness: true


  def calves
    Animal.where(dam_birth_id: self.birth_id)
  end
end
