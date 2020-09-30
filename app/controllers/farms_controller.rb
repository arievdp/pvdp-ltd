class FarmsController < ApplicationController
  # Controller for farms and farm stats
  before_action :set_farm, only: [:show, :show_animals]
  before_action :set_farms, only: [:index, :show]

  def index; end

  def show
    # Set year for views
    @year = Date.today.year
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
    f = Farm.find_by(code: farm_params[:file].original_filename[0..8])
    Animal.import(farm_params, f)
    if Animal.duplicates?
        redirect_to duplicates_path
    else
      redirect_to farm_path(f)
    end
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

end
