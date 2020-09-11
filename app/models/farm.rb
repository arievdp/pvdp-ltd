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

  def heifers_first_calved
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

  # Statistics
  ###################

  # Herd calving rate
  def stat_hcr
    percentage(self.heifers, self.heifers_calved)
  end

  # First time calving rate
  def stat_ftc
    percentage(self.heifers_first, self.heifers_first_calved)
  end

  # Cow death rate
  def stat_cow_dr
    percentage(self.heifers, self.heifers_died)
  end

  # Heifer Replacment rate
  def stat_hrr
    percentage(self.heifers, self.calves)
  end

  # Calf death rate
  def stat_calf_dr
    percentage(self.calves, self.calves_died)
  end

  private

  def percentage(a, b)
    ((b.count.to_f / a.count.to_f) * 100).round(2)
  end

end
