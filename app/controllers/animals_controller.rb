class AnimalsController < ApplicationController
    before_action :set_farm, only: [:index, :update]
    before_action :set_animal, only: [:edit, :update]

    def index
        @animals = @farm.animals
    end

    def edit
        
    end

    def update
        @animal.update(animal_params)
        if Animal.duplicates?.exists?
            redirect_to '/duplicates'
        else
            redirect_to farm_path(@farm)
        end
    end

    def duplicates
        @animals = Animal.duplicates?
    end

    private

    def set_animal
        @animal = Animal.find(params[:id])
    end

    def set_farm
        @farm = Farm.find(animal_params[:farm_id])
    end

    def animal_params
        params.require(:animal).permit(
            :id,
            :farm_id,
            :birth_id, 
            :cow_number, 
            :bw_value, 
            :bw_reliability, 
            :pw_value, 
            :pw_reliability, 
            :a2_status, 
            :fate, 
            :expected_calving_date,
            :calving_date,
            :calf_birth_id, 
            :calf_birth_date,
            :calf_sex, 
            :calf_fate, 
            :dam_birth_id, 
            :dam_cow_number, 
            :sire_birth_id, 
            :sire_name, 
        )
    end

end
