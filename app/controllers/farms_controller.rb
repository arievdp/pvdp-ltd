class FarmsController < ApplicationController
  # Controller for farms and farm stats
  before_action :set_farm, only: [:show]
  before_action :set_farms, only: [:index, :show]

  def index; end

  def show
    # Set year for views
    @year_minus_2 = (Date.today.year - 2)

    # Set animal numbers
    @animals = @farm.animals
    @calves = @farm.calves
    @heifers = @farm.heifers
    @hf = @farm.heifers_first
    @hfc = @farm.heifers_first_calved

    # First time calving rate
    @ftc_perc = @farm.stat_ftc

    # Herd calving rate
    @hcr_perc = @farm.stat_hcr

    # Cow death rate
    @cow_dr = @farm.stat_cow_dr

    # Heifer Replacment rate
    @hr_perc = @farm.stat_hrr

    # Calf death rate
    @calf_dr = @farm.stat_calf_dr

    # Calving stats for time range
    @day = day
    @week = week
    @month = month
    @season = season
  end

  def process_csv
    farm = Farm.find(farm_params[:farm])
    options = {
      key_mapping: {
      animal_birth_id_1: :birth_id,
      animal_animal_id: :cow_number,
      animal_bw_1_value: :bw_value,
      animal_bw_1_reliability: :bw_reliability,
      animal_pw_value: :pw_value,
      animal_pw_reliability: :pw_reliability,
      animal_a2_status: :a2_status,
      expected_calving_date: :expected_calving_date,
      animal_calving_date: :calving_date,
      calf_birth_id_2: :calf_birth_id,
      calf_birth_date: :calf_birth_date,
      dam_official_id: :dam_birth_id,
      sire_sire_id: :sire_birth_id,
      }
    }
    data = SmarterCSV.process(farm_params[:file], options)
    raise


    farm_info(data, farm)
    redirect_to farm_path(farm)
  end

  private

  def farm_params
    params.require(:farm).permit(:farm, :file)
  end

  def set_farm
    @farm = Farm.find(params[:id])
  end

  def set_farms
    @farms = Farm.all
  end

  # methods for statistics
  def percentage(a, b)
    ((b.count.to_f / a.count.to_f) * 100).round(2)
  end

  def day
    @calves.where(birth_date: (1.days.ago..Time.now))
  end

  def week
    @calves.where(birth_date: (1.weeks.ago..Time.now))
  end

  def month
    @calves.where(birth_date: (1.months.ago..Time.now))
  end

  def season
    @calves.where(birth_date: (1.years.ago..Time.now))
  end

  def farm_info(data, farm)
    data.each do |d|
      create_animal(farm, d) if d[:animal_birth_id_1].present?
      # update_animal(farm, d) if d[:animal_birth_id_1].present? && !unique_birth_id?(d[:animal_birth_id_1])
      create_calf(farm, d) if d[:calf_birth_id_2].present? && unique_birth_id?(d[:calf_birth_id_2])
      raise
    end
  end

  def create_animal(farm, d)
    a = Animal.new(
      farm: farm,
      birth_id: d[:animal_birth_id_1],
      cow_number: d[:animal_animal_id],
      birth_date: DateTime.strptime("20#{d[:animal_birth_id_1].match(/[0-9]{2}/)}", '%Y'),
      bw_value: d[:calf_bw_2_value],
      bw_reliability: d[:animal_bw_1_relability],
      pw_value: d[:animal_pw_value],
      pw_reliability: d[:animal_pw_reliability],
      a2_status: d[:animal_a2_status],
      fate: d[:"animal_custom:_animal_fate_(died)"],
      expected_calving_date: d[:expected_calving_date],
      calving_date: d[:animal_calving_date],
      calf_birth_id: d[:calf_birth_id_2],
      calf_birth_date: d[:calf_birth_date],
      calf_sex: d[:calf_sex],
      calf_fate: d[:calf_fate],
      dam_birth_id: d[:dam_official_id],
      dam_cow_number: d[:"dam_cow_no."],
      sire_birth_id: d[:sire_sire_id],
      sire_name: d[:sire_name],
      sex: "F",
    )
    if unique_birth_id?(a.birth_id)
      a.save!
    else
      b = Animal.find_by(birth_id: a.birth_id)
      b = a
      b.update!
    end
  end

  def unique_birth_id?(d)
    !Animal.where(birth_id: d).exists?
  end

  def create_calf
    Animal.create(
      farm: farm,
      birth_id: d[:calf_birth_id_2],
      birth_date: d[:calf_birth_date],
      bw_value: d[:calf_bw_2_value],
      bw_reliability: d[:calf_bw_2_reliability],
      sex: d[:calf_sex],
      fate: d[:calf_fate],
      dam_birth_id: d[:animal_birth_id_1],
      dam_cow_number: d[:animal_animal_id],
    )
  end

  def diff_active_record(record_a, record_b)
    (record_a.attributes.to_a - record_b.attributes.to_a).map(&:first)
  end

end
