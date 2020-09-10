class FarmsController < ApplicationController
  before_action :set_farm

  def show
    @year = Date.today.year
    @year_minus_2 = (@year - 2)
    @animals = @farm.animals
    @animals_calved = @farm.animals_calved
    @animals_calved_count = @animals_calved.count

    @heifers = @farm.heifers
    @heifers_count = @heifers.count
    @heifer_deaths = @heifers.where(fate: "Died")
    @heifer_death_percentage = (@heifer_deaths.count.to_f / @heifers.count.to_f) * 100

    @first_time_heifers = @heifers.select { |h| h.birth_date.year == @year_minus_2 }
    @first_time_heifers_calved = @first_time_heifers.select { |h| h.calf_birth_date != nil }
    @first_time_calvers_percentage = (@first_time_heifers_calved.count.to_f / @first_time_heifers.count.to_f).round(2) * 100

    # heifer replacement
    @hr = @heifers.where(calf_sex: "F").where(calf_fate: "Reared")
    @hr_percentage = (@hr.count.to_f / @farm.animals_calved.count.to_f).round(2) * 100

    # calf death rate
    @cdr = @heifers.where(calf_fate: "Died")
    @cdr_percentage = (@cdr.count.to_f / @farm.calves.count.to_f).round(2) * 100

    @animals_calved_percentage = (@animals_calved_count.to_f / @heifers_count.to_f).round(2) * 100

    # time ranges
    time_range = (1.days.ago..Time.now)
    @today = @farm.calves.where(birth_date: time_range)
    time_range = (1.weeks.ago..Time.now)
    @this_week = @farm.calves.where(birth_date: time_range)
    time_range = (1.months.ago..Time.now)
    @this_month = @farm.calves.where(birth_date: time_range)
    time_range = (1.years.ago..Time.now)
    @this_year = @farm.animals.where(birth_date: time_range)

  end

  private

  def set_farm
    @farm = Farm.find(params[:id])
  end
end
