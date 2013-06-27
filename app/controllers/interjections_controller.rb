class InterjectionsController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_interjection, only: [:show, :edit, :update, :destroy]

  # GET /interjections
  # GET /interjections.json
  def index
    @interjections = Interjection.all
  end

  # GET /interjections/1
  # GET /interjections/1.json
  def show
  end

  # GET /interjections/new
  def new
    @interjection = Interjection.new
  end

  # GET /interjections/1/edit
  def edit
  end

  # POST /interjections
  # POST /interjections.json
  def create
    @interjection = Interjection.new(interjection_params)

    respond_to do |format|
      if @interjection.save
        format.html { redirect_to @interjection, notice: 'Interjection was successfully created.' }
        format.json { render action: 'show', status: :created, location: @interjection }
      else
        format.html { render action: 'new' }
        format.json { render json: @interjection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /interjections/1
  # PATCH/PUT /interjections/1.json
  def update
    respond_to do |format|
      if @interjection.update(interjection_params)
        format.html { redirect_to @interjection, notice: 'Interjection was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @interjection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /interjections/1
  # DELETE /interjections/1.json
  def destroy
    @interjection.destroy
    respond_to do |format|
      format.html { redirect_to interjections_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_interjection
      @interjection = Interjection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def interjection_params
      params.require(:interjection).permit(:name, :updated_by, :created_by)
    end
end
