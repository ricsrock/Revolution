class SmallGroupsController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_group, only: [:show, :edit, :update, :destroy, :sms]
  
  def index
    # SmallGroup.fix_params(params[:q]) if params[:q]
    @q = SmallGroup.status(params[:q]).page(params[:page]).search(params[:q])
    @small_groups = @q.result(distinct: true)
    @status = 'Active'
    @status = params[:q][:status_cont] if params[:q] && params[:q][:status_cont]
  end
  
  def show
    
  end
  
  def edit
    
  end
  
  def new
    @small_group = SmallGroup.new
  end
  
  def create
    @small_group = SmallGroup.new(small_group_params)

    respond_to do |format|
      if @small_group.save
        Group.rebuild!
        format.html { redirect_to @small_group.becomes(Group), notice: 'Group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @small_group }
      else
        flash[:error] = "There were errors: #{@small_group.errors.messages[:base].to_sentence rescue nil}"
        format.html { render action: 'new' }
        format.json { render json: @small_group.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @small_group.update(small_group_params)
        Group.rebuild!
        format.html { redirect_to @small_group.becomes(Group), notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end
  
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @small_group = SmallGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def small_group_params
      params.require(:small_group).permit(:name, :default_room_id, :staff_ratio, :meeting_is_called, :checkin_group, :cadence_id, :parent_id, :id,
                                          :blurb, :description, weekday_ids: [], meeting_time_ids: [],
                                          primary_leaderships_attributes: [:person_name, :title, :_destroy, :id],
                                          support_leaderships_attributes: [:person_name, :title, :_destroy, :id],
                                          frequency: [:name, :cadence_id])
    end
  
end
