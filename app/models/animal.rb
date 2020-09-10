class Animal < ApplicationRecord
  belongs_to :farm
  validates :birth_id, presence: true, uniqueness: true
  before_create :heifer?

  def calves
    Animal.where(dam_birth_id: birth_id)
  end

  private

  def heifer?
    current_year = Time.current.year
    a = self
    if a[:birth_date].to_date.year == current_year
      a[:status] = 'calf'
    elsif a[:birth_date].to_date.year == (current_year - 1)
      a[:status] = 'yearling'
    else
      a[:status] = 'heifer'
    end
  end
end
