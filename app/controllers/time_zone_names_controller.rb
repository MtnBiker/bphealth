class TimeZoneNamesController < ApplicationController
  before_action :set_time_zone_name, only: %i[ show edit update destroy ]

  # GET /time_zone_names or /time_zone_names.json
  def index
    @time_zone_names = TimeZoneName.all
  end

  # GET /time_zone_names/1 or /time_zone_names/1.json
  def show
  end

  # GET /time_zone_names/new
  def new
    @time_zone_name = TimeZoneName.new
  end

  # GET /time_zone_names/1/edit
  def edit
  end

  # POST /time_zone_names or /time_zone_names.json
  def create
    @time_zone_name = TimeZoneName.new(time_zone_name_params)

    respond_to do |format|
      if @time_zone_name.save
        format.html { redirect_to time_zone_name_url(@time_zone_name), notice: "Time zone name was successfully created." }
        format.json { render :show, status: :created, location: @time_zone_name }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @time_zone_name.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /time_zone_names/1 or /time_zone_names/1.json
  def update
    respond_to do |format|
      if @time_zone_name.update(time_zone_name_params)
        format.html { redirect_to time_zone_name_url(@time_zone_name), notice: "Time zone name was successfully updated." }
        format.json { render :show, status: :ok, location: @time_zone_name }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @time_zone_name.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_zone_names/1 or /time_zone_names/1.json
  def destroy
    @time_zone_name.destroy

    respond_to do |format|
      format.html { redirect_to time_zone_names_url, notice: "Time zone name was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_zone_name
      @time_zone_name = TimeZoneName.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def time_zone_name_params
      params.require(:time_zone_name).permit(:name, :abbrev, :utc_offset, :is_dst)
    end
end
