class AnimalsController < ApplicationController
    before_action :set_farm, only: [:index]
    before_action :set_animal, only: [:edit]

    def index
        @animals = @farm.animals
    end

    def edit
        
    end

    def duplicates
        @animals = Animal.duplicates?
    end

    private

    def set_animal
        @animal = Animal.find(params[:id])
    end

    def set_farm
        @farm = Farm.find(params[:farm_id])
    end

end
