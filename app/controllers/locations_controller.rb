class LocationsController < ApplicationController
  layout 'table', only: [:index]
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  before_action :current_user_can_write, only: [:index, :show, :edit, :update, :destroy]

  # GET /locations
  def index
    @locations = Location.all
  end

  # GET /locations/1
  def show
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  def create
    @location = Location.new(location_params)

    if @location.save
      redirect_to @location, notice: 'Location was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /locations/1
  def update
    if @location.update(location_params)
      redirect_to @location, notice: 'Location was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /locations/1
  def destroy
    if @location.destroy
      redirect_to locations_url, notice: 'Location was successfully destroyed.'
    else
      redirect_to locations_url, alert: "Brisanje lokacije nije moguće jer je u upotrebi"
    end
    
  end

  private
  
    def current_user_can_write
      raise "[LocationsController#current_user_can_write]" unless current_user.admin
    end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def location_params
      params.require(:location).permit(:title, :lat, :lng, :description, :map_image_url)
    end
end
