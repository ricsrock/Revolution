class InstanceTypesController < ApplicationController
  before_action :set_instance_type, only: [:show, :edit, :update, :destroy]

  # GET /instance_types
  # GET /instance_types.json
  def index
    @instance_types = InstanceType.all
  end

  # GET /instance_types/1
  # GET /instance_types/1.json
  def show
  end

  # GET /instance_types/new
  def new
    @instance_type = InstanceType.new
  end

  # GET /instance_types/1/edit
  def edit
  end

  # POST /instance_types
  # POST /instance_types.json
  def create
    @instance_type = InstanceType.new(instance_type_params)

    respond_to do |format|
      if @instance_type.save
        format.html { redirect_to @instance_type, notice: 'Instance type was successfully created.' }
        format.json { render action: 'show', status: :created, location: @instance_type }
      else
        format.html { render action: 'new' }
        format.json { render json: @instance_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /instance_types/1
  # PATCH/PUT /instance_types/1.json
  def update
    respond_to do |format|
      if @instance_type.update(instance_type_params)
        format.html { redirect_to @instance_type, notice: 'Instance type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @instance_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /instance_types/1
  # DELETE /instance_types/1.json
  def destroy
    @instance_type.destroy
    respond_to do |format|
      format.html { redirect_to instance_types_url }
      format.json { head :no_content }
    end
  end
  
  def add_group_to
    @group = Group.find(params[:id])
    @instance_type = InstanceType.find(params[:instance_type_id])
    @instance_type.groups << @group
  end
  
  def remove_group_from
    @group = Group.find(params[:id])
    @instance_type = InstanceType.find(params[:instance_type_id])
    @instance_type.groups.delete(@group)
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instance_type
      @instance_type = InstanceType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def instance_type_params
      params.require(:instance_type).permit(:name, :start_time)
    end
end
