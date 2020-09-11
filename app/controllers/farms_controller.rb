class FarmsController < ApplicationController
  # Controller for farms and farm stats
  before_action :set_farm, only: :show

  def show
    @farms = Farm.all

    # Set year for views
    @year_minus_2 = (Date.today.year - 2)

    # Set animal numbers
    @animals = @farm.animals
    @calves = @farm.calves
    @heifers = @farm.heifers
    @hf = @farm.heifers_first
    @hfc = @farm.heifer_first_calved

    # First time calving rate
    @ftc_perc = percentage(@hf, @hfc)

    # Herd calving rate
    @hcr_perc = percentage(@heifers, @farm.heifers_calved)

    # Cow death rate
    @cow_dr = percentage(@heifers, @farm.heifers_died)

    # Heifer Replcament rate
    @hr_perc = percentage(@heifers, @farm.heifers_calved)

    # Calf death rate
    @calf_dr = percentage(@calves, @farm.calves_died)

    # Calving stats for time range
    @day = day
    @week = week
    @month = month
    @season = season
  end

  private

  def set_farm
    @farm = Farm.find(params[:id])
  end

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
