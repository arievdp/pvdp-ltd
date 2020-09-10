class Farm < ApplicationRecord
  has_many :animals
  has_many :employments
  has_many :users, through: :employments

  def animals_calved
    animals.where.not(calving_date: [nil, false])
  end

  def calves
    animals.where(status: 'calf', fate: 'Reared')
  end

  def calves_dead
    animals.where(calf_fate: 'Died')
  end

  def yearlings
    animals.where(status: 'yearling')
  end

  def heifers
    animals.where(status: 'heifer')
  end
end
