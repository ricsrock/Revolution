class CommTypesController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_comm_type, only: [:show, :edit, :update, :destroy]

  # GET /comm_types
  # GET /comm_types.json
  def index
    @comm_types = CommType.all
  end

  # GET /comm_types/1
  # GET /comm_types/1.json
  def show
  end

  # GET /comm_types/new
  def new
    @comm_type = CommType.new
  end

  # GET /comm_types/1/edit
  def edit
  end

  # POST /comm_types
  # POST /comm_types.json
  def create
    @comm_type = CommType.new(comm_type_params)

    respond_to do |format|
      if @comm_type.save
        format.html { redirect_to @comm_type, notice: 'Comm type was successfully created.' }
        format.json { render action: 'show', status: :created, location: @comm_type }
      else
        format.html { render action: 'new' }
        format.json { render json: @comm_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comm_types/1
  # PATCH/PUT /comm_types/1.json
  def update
    respond_to do |format|
      if @comm_type.update(comm_type_params)
        format.html { redirect_to @comm_type, notice: 'Comm type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @comm_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comm_types/1
  # DELETE /comm_types/1.json
  def destroy
    @comm_type.destroy
  rescue => e
    if e
      flash[:alert] = "#{e}"
    else
      flash[:notice] = "Communication Type was successfully destroyed."
    end
    respond_to do |format|
      format.html { redirect_to comm_types_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comm_type
      @comm_type = CommType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comm_type_params
      params.require(:comm_type).permit(:name, :id)
    end
end
