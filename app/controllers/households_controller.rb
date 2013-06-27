class HouseholdsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_household, only: [:show, :edit, :update, :destroy, :map]
  authorize_resource
  # GET /households
  # GET /households.json
  def index
    @households = Household.page(params[:page]).order(:name)
  end

  # GET /households/1
  # GET /households/1.json
  def show
  end

  # GET /households/new
  def new
    @household = Household.new
  end

  # GET /households/1/edit
  def edit
  end

  # POST /households
  # POST /households.json
  def create
    @household = Household.new(household_params)

    respond_to do |format|
      if @household.save
        format.html { redirect_to @household, notice: 'Household was successfully created.' }
        format.json { render action: 'show', status: :created, location: @household }
      else
        format.html { render action: 'new' }
        format.json { render json: @household.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /households/1
  # PATCH/PUT /households/1.json
  def update
    respond_to do |format|
      if @household.update(household_params)
        format.html { redirect_to @household, notice: 'Household was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @household.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /households/1
  # DELETE /households/1.json
  def destroy
    @household.destroy
    respond_to do |format|
      format.html { redirect_to households_url }
      format.json { head :no_content }
    end
  end
  
  def map
    @json = @household.to_gmaps4rails
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_household
      @household = Household.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def household_params
      params.require(:household).permit(:name, :address1, :address2, :city, :state, :zip,
                                        people_attributes: [:first_name, :last_name, :gender, :household_position, :birthdate, :id, :allergies, :default_group_id, :_destroy],
                                        phones_attributes: [:number, :primary, :comments, :_destroy, :id, :comm_type_id])
    end
end
