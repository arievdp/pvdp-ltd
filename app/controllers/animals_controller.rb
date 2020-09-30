class AnimalsController < ApplicationController
    before_action :set_farm, only: [:index]

    def index
        @animals = @farm.animals
    end

    def duplicates
        @animals = Animal.duplicates?
    end

    private

    def set_farm
        @farm = Farm.find(params[:farm_id])
    end

end
