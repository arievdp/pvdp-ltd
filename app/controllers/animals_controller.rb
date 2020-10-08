class AnimalsController < ApplicationController
    before_action :set_farm, only: [:update]
    before_action :set_animal, only: [:edit, :update, :destroy]
    helper_method :sort_column, :sort_direction

    def index
        @farm = Farm.find(params[:farm_id])
        @animals = @farm.animals.order(sort_column + " " + sort_direction)
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

    def destroy
        @animal.destroy
        redirect_to farm_animals_path(@animal[:farm_id], @animal[:id])
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

    def sort_column
        Animal.column_names.include?(params[:sort]) ? params[:sort] : 'birth_id'
    end

    def sort_direction
        %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
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
