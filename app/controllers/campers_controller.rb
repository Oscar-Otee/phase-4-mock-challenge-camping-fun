class CampersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_response

    def index
        campers = Camper.all
        render json: campers, status: :ok
    end

    def show
        camper = Camper.find_by!(id: params[:id])
        render json: camper, serializer: CampersAndActivitiesSerializer, status: :ok
    end
    
    def create
        camper = Camper.create!(camper_params)
        render json: camper, status: :created
    end

    private

    def camper_params
        params.permit(:name, :age)
    end
    
    def unprocessable_entity_response(invalid)
        render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end

    def render_not_found_response
        render json: { error: "Camper not found" }, status: :not_found
    end
end
