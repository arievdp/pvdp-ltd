class Animal < ApplicationRecord
  belongs_to :farm
  validates :birth_id, presence: true, uniqueness: true
  before_create :heifer?

  def calved?
    calf_birth_date.present?
  end

  def alive?
    fate != 'Died'
  end

  private

  def heifer?
    current_year = Time.current.year
    a = self
    if a[:birth_date].to_date.year == current_year
      a[:status] = 'Calf'
    elsif a[:birth_date].to_date.year == (current_year - 1)
      a[:status] = 'Yearling'
    else
      a[:status] = 'Heifer'
    end
  end
end
