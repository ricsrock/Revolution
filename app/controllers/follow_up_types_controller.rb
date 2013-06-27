class FollowUpTypesController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_follow_up_type, only: [:show, :edit, :update, :destroy]

  # GET /follow_up_types
  # GET /follow_up_types.json
  def index
    @follow_up_types = FollowUpType.all
  end

  # GET /follow_up_types/1
  # GET /follow_up_types/1.json
  def show
  end

  # GET /follow_up_types/new
  def new
    @follow_up_type = FollowUpType.new
  end

  # GET /follow_up_types/1/edit
  def edit
  end

  # POST /follow_up_types
  # POST /follow_up_types.json
  def create
    @follow_up_type = FollowUpType.new(follow_up_type_params)

    respond_to do |format|
      if @follow_up_type.save
        format.html { redirect_to @follow_up_type, notice: 'Follow up type was successfully created.' }
        format.json { render action: 'show', status: :created, location: @follow_up_type }
      else
        format.html { render action: 'new' }
        format.json { render json: @follow_up_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /follow_up_types/1
  # PATCH/PUT /follow_up_types/1.json
  def update
    respond_to do |format|
      if @follow_up_type.update(follow_up_type_params)
        format.html { redirect_to @follow_up_type, notice: 'Follow up type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @follow_up_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /follow_up_types/1
  # DELETE /follow_up_types/1.json
  def destroy
    @follow_up_type.destroy
    respond_to do |format|
      format.html { redirect_to follow_up_types_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_follow_up_type
      @follow_up_type = FollowUpType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def follow_up_type_params
      params.require(:follow_up_type).permit(:name)
    end
end
