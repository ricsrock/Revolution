class GroupsController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_group, only: [:show, :edit, :update, :destroy, :sms, :email, :enroll,
                                   :export_people, :setup_promote_for, :promote, :export_vcards]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @value ||= 'current'
    user_session[:return_to] = request.referrer
    logger.info "==== session:return_to set to #{user_session[:return_to]} ==== request.referrer is: #{request.referrer}"
    respond_to do |format|
      format.html
      format.pdf do
        pdf = GroupRosterPdf.new(@group, view_context)
        filename = @group.name.gsub(/[^0-9a-z]/, "_") + "_roster" + ".pdf"
        send_data pdf.render, filename: filename,
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
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
        flash[:error] = "There were errors: #{@group.errors.messages[:base].to_sentence}"
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
        Group.rebuild!
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
      flash[:notice] = "The group was destroyed forever."
      Group.rebuild!
    else
      flash[:error] = "The group could not be detroyed. #{@group.errors.full_messages.collect {|m| m}.to_sentence}"
    end
    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end
  
  def sms
    @message = Message.new
    if @group.has_children?
      @enrollments = @group.descendants_enrollments
    else
      @enrollments = @group.enrollments.current
    end
  end
  
  def email
    logger.info "==== session:return_to set to #{user_session[:return_to]} ==== request.referrer is: #{request.referrer}"
    if @group.has_children?
      @enrollments = @group.descendants_enrollments
    else
      @enrollments = @group.enrollments.current
    end
  end
  
  def export_people
    if @group.has_children?
      @enrollments = @group.descendants_enrollments
    else
      @enrollments = @group.enrollments.current
    end
    filename = @group.name.downcase.gsub(/[^0-9a-z]/, "_") + "_people.csv"
    send_data Enrollment.to_csv(@enrollments), type: "text/csv", filename: filename, disposition: :attachment
  end
  
  def jump_to
    @group = Group.find(params[:group_id])
    @partial_name = @group.partial_name
  end
  
  def filter_enrollments
    @value = params[:value]
    @group = Group.find(params[:id])
  end
  
  def roster
    respond_to do |format|
      format.html
      format.pdf do
        pdf = GroupRosterPdf.new(@group, view_context)
        filename = @group.name.gsub(/[^0-9a-z]/, "_") + "_roster" + ".pdf"
        send_data pdf.render, filename: filename,
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def archive
    @group = Group.find(params[:id])
    @group.archive!
    flash[:notice] = "This group has been archived."
    redirect_to @group.becomes(Group)
  end
  
  def activate
    @group = Group.find(params[:id])
    @group.activate!
    flash[:notice] = "This group has been activated."
    redirect_to @group.becomes(Group)
  end
  
  def enroll
    @available_people = @group.available_people.limit(20).order('last_name, first_name ASC')
  end
  
  def search_people
    @group = Group.find(params[:id])
    term = params[:term]
    names = params[:term].gsub(",", " ").split(' ')
    if names.length == 1
      conditions = ["last_name LIKE ? OR first_name LIKE ? OR emails.email LIKE ?", "%#{names[0].strip}%", "%#{names[0].strip}%", term]
    elsif names.length >= 2
      conditions = ["last_name LIKE ? AND first_name LIKE ? OR (first_name LIKE ? AND last_name LIKE ?) OR emails.email LIKE ?", "%#{names[0].strip}%", "%#{names[1].strip}%", "%#{names[0].strip}%", "%#{names[1].strip}%", term]
    end
    @available_people = @group.available_people.where(conditions).limit(20).includes(:emails)
  end
  
  def enroll_person
    @group = Group.find(params[:id])
    @person = Person.find(params[:person_id])
    @result = @group.enroll!(@person)
    if @result == true
      flash[:notice] = "Person was successfully enrolled."
    else
      flash[:error] = "Person could not be enrolled: #{@result.errors.full_messages.to_sentence}."
    end
  end
  
  def setup_promote_for
    
  end
  
  def promote
    @from_group = Group.find(params[:id])
    @to_group = Group.find(params[:promote_to_id])
    @ids = params[:selected_ids]
    @ids.each do |id|
      person = Person.find(id)
      person.promote!(@from_group, @to_group)
    end
    flash[:notice] = "The selected people were succesfully promoted."
    redirect_to group_url(@to_group)
  end
  
  def export_vcards
    batch_of_cards = ''
    @group.enrollments.current.each do |enrollment|
      if enrollment.person
        batch_of_cards << enrollment.person.to_vcard if enrollment.person.to_vcard
      end
    end
    send_data batch_of_cards, :filename => "group_#{@group.id}_cards.vcf"
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :default_room_id, :staff_ratio, :meeting_is_called, :checkin_group, :parent_id, :id, :description)
    end
end
