class Farm < ApplicationRecord
  # Farms containing animals
  has_many :animals
  has_many :employments
  has_many :users, through: :employments

  def calves
    animals.where(status: 'Calf').where.not(fate: 'Died')
  end

  def yearlings
    animals.where(status: 'Yearling').where(fate: [nil, false])
  end

  def heifers
    animals.where(status: 'Heifer').where(fate: [nil, false])
  end

  def heifers_died
    animals.where(status: 'Heifer').where(fate: 'Died')
  end

  def heifers_calved
    animals.where(status: 'Heifer').where.not(calving_date: [nil, false])
  end

  def heifers_not_calved
    animals.where(status: 'Hiefer').where(calving_date: [nil, false])
  end

  def heifers_first
    animals.where(status: 'Heifer').where(birth_date: (3.years.ago..Time.now))
  end

  def heifer_first_calved
    animals.where(status: 'Heifer').where(birth_date: (3.years.ago..Time.now)).where.not(calving_date: [nil, false])
  end

  def calves_died
    animals.where(calf_fate: 'Died')
  end

  def calves_bobbied
    animals.where(calf_fate: 'Bobbied')
  end

  def calves_died_bobbied
    animals.where(status: 'Hiefer').where(calf_fate: ['Died', 'Bobbied'])
  end
end
