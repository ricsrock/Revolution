class Admin::GroupsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_admin
  before_action :set_group, only: [:show, :edit, :update, :destroy, :convert]
  
  
  # GET /groups
  # GET /groups.json
  def index
    @q = Group.page(params[:page]).search(params[:q])
    @groups = @q.result(distinct: true)
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    if @group.destroy
      Group.rebuild!
    end
    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end
  
  def sms
    @message = Message.new
  end
  
  def convert
    @group.convert!(params[:klass])
    if @group.errors.any?
      flash[:error] = "Could not convert: #{@group.errors.full_messages.collect {|m| m}.to_sentence}"
    else
      flash[:notice] = "Successfully converted."
    end
    redirect_to admin_groups_url
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :default_room_id, :staff_ratio, :meeting_is_called, :checkin_group, :parent_id, :id)
    end
end