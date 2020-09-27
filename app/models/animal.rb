class Animal < ApplicationRecord
  belongs_to :farm
  validates :birth_id, presence: true, uniqueness: true
  before_create :set_birth_date, :heifer?
  before_update :heifer?

  def calved?
    calf_birth_date.present?
  end

  def alive?
    fate != 'Died'
  end

  def self.import(params, f)
    SmarterCSV.process(params[:file], Animal.csv_options) do |array|
      a = array.first
      create_heifer(a, f) if a[:birth_id].present?
      create_calf(a, f) if a[:calf_birth_id].present?
    end
  end

  private

  def self.csv_options
    # Use these keys to change the defauly naming of the CSV columns
    {
      key_mapping: 
      {
        animal_birth_id_1: :birth_id,
        animal_birth_id: :birth_id,
        animal_animal_id: :cow_number,
        animal_bw_1_value: :bw_value,
        animal_bw_1_reliability: :bw_reliability,
        animal_pw_value: :pw_value,
        animal_pw_reliability: :pw_reliability,
        animal_a2_status: :a2_status,
        expected_calving_date: :expected_calving_date,
        pre_calving_expected_calving_date: :expected_calving_date,
        animal_calving_date: :calving_date,
        calf_birth_id_2: :calf_birth_id,
        calf_birth_date: :calf_birth_date,
        dam_official_id: :dam_birth_id,
        "dam_cow_no.": :dam_cow_number,
        sire_sire_id: :sire_birth_id,
        "animal_custom:_animal_fate_(died)": :fate,
        calf_bw_2_value: :calf_bw,
        calf_bw_2_reliability: :calf_bw_reliability,
        calf_sex: :calf_sex,
        calf_fate: :calf_fate,
      }
    }
  end

  def self.create_heifer(a, f)
    n = Animal.find_or_create_by(birth_id: a[:birth_id])
    n.update_attributes(
      farm: f,
      birth_id: a[:birth_id],
      cow_number: a[:cow_number],
      bw_value: a[:bw_value],
      bw_reliability: a[:bw_reliability],
      pw_value: a[:pw_value],
      pw_reliability: a[:pw_reliability],
      a2_status: a[:a2_status],
      fate: a[:fate],
      expected_calving_date: set_date(a[:expected_calving_date]),
      calving_date: set_date(a[:calving_date]),
      calf_birth_id: a[:calf_birth_id],
      calf_birth_date: set_date(a[:calf_birth_date]),
      calf_sex: a[:calf_sex],
      calf_fate: a[:calf_fate],
      dam_birth_id: a[:dam_birth_id],
      dam_cow_number: a[:dam_cow_number],
      sire_birth_id: a[:sire_birth_id],
      sire_name: a[:sire_name],
    )
  end

  def self.create_calf(a, f)
    n = Animal.find_or_create_by(birth_id: a[:calf_birth_id])
    n.update_attributes(
      farm: f,
      birth_id: a[:calf_birth_id],
      birth_date: set_date(a[:calf_birth_date]),
      bw_value: a[:calf_bw],
      bw_reliability: a[:calf_bw_reliability],
      sex: a[:calf_sex],
      fate: a[:calf_fate],
      dam_birth_id: a[:birth_id],
      dam_cow_number: a[:cow_number],
    )
  end

  # def self.duplicate?(a)
  #   Animal.where(birth_id: a[:birth_id]).exists?
  # end

  def self.set_date(a)
    Date.parse(a) unless a.nil?
  end

  def set_birth_date
    self[:birth_date] = DateTime.strptime("20#{self[:birth_id].match(/[0-9]{2}/)}", '%Y') if self[:birth_date].nil?
  end

  def self.set_calving_date
    self[:calving_date] = Date.parse(self[:calving_date]) unless self[:calving_date].nil?
  end

  def heifer?
    current_year = Time.current.year
    a = self
    if a[:birth_date].to_date.year == current_year
      a[:status] = 'Calf'
    elsif a[:birth_date].to_date.year == (current_year - 1)
      a[:status] = 'Yearling'
      a[:sex] = "F"
    else
      a[:status] = 'Heifer'
      a[:sex] = "F"
    end
  end
end
