class PeopleController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_person, only: [:show, :edit, :update, :destroy, :edit_image, :image_from_facebook, :setup_move_for, :move,
                                    :setup_merge_for, :merge, :export_vcard]

  load_and_authorize_resource
  skip_load_and_authorize_resource only: [:new, :create]

  # GET /people
  # GET /people.json
  def index
    @people = Person.all
  end

  # GET /people/1
  # GET /people/1.json
  def show
    @att_search = @person.attendances.page(params[:page]).search(params[:q])
    @att_search.sorts = 'meeting_instance_event_date desc' if @att_search.sorts.empty?
    @att_result = @att_search.result(distinct: true)
  end

  # GET /people/new
  def new
    @person = Person.new
    @household_id = params[:household_id]
  end

  # GET /people/1/edit
  def edit
    @household_id = @person.household.id
  end
  
  def edit_image
    
  end
  
  def image_from_facebook
    if @person.get_facebook_profile_pic
      @person.update_attribute(:has_a_picture, @person.image.present?)
      flash[:notice] = "Profile pic was updated from Facebook."
    else
      flash[:alert] = "Profile pic could not be updated from Facebook. Please ensure the person's Facebook URL is correct."
    end
    redirect_to @person
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        format.html { redirect_to @person, notice: 'Person was successfully created.' }
        format.json { render action: 'show', status: :created, location: @person }
      else
        format.html { render action: 'new' }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        @person.update_attribute(:has_a_picture, @person.image.present?)
        format.html { redirect_to @person, notice: 'Person was successfully updated.' }
        format.json { head :no_content }
      else
        @household_id = @person.household.id
        format.html { render action: 'edit' }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to people_url }
      format.json { head :no_content }
    end
  end
  
  def search
    @people = Person.order(:last_name).order(:first_name).where('last_name LIKE ? OR first_name LIKE ?',"%#{params[:term].strip}%", "%#{params[:term].strip}%")
    render json: @people.map(&:id_and_full_name)
  end
  
  def setup_move_for
    @results = []
  end
  
  def move
    @person = Person.find(params[:id])
    @new_household = Household.find(params[:new_household_id])
    @person.household_id = @new_household.id
    @person.save!
    flash[:notice] = "#{@person.full_name} has been moved to the #{@new_household.name} household."
    redirect_to @new_household
  end
  
  def search_household
    @results = Household.where('name LIKE ?', "%#{params[:q].strip}%").order('households.name, households.id ASC')
      .includes(:people).references(:people).limit(20)
  end
  
  def choose_household
    @new_household = Household.find(params[:household_id])
  end
  
  def setup_merge_for
    @results = []
  end
  
  def search_person
    term = params[:q]
    term = 'xzxzxzxzxzxzxzxzxzx' if term == ""
    terms = term.split(',')
    dup_id = params[:duplicate_id]
    if terms.length == 1
      conditions = ["last_name LIKE ? AND id != ?", "%#{terms.first.strip}%", dup_id]
    else
      conditions = ["last_name LIKE ? AND first_name LIKE ? AND id != ?", "%#{terms.first.strip}%", "%#{terms.last.strip}%", dup_id]
    end
    @results = Person.where(conditions).order('last_name, first_name ASC').limit(20)
  end
  
  def choose_person
    @keeper = Person.find(params[:person_id])
  end
  
  def merge
    @person = Person.find(params[:id])
    @keeper = Person.find(params[:keeper_id])
    @person.merge_phones_into(@keeper)
    @person.merge_emails_into(@keeper)
    @person.merge_attendances_into(@keeper)
    @person.merge_enrollments_into(@keeper)
    @person.merge_taggings_into(@keeper)
    @person.merge_attendance_trackers_into(@keeper)
    @person.merge_contacts_into(@keeper)
    @person.merge_contributions_into(@keeper)
    @abandoned = Person.find(@person.id)
    @abandoned.destroy
    flash[:notice] = "Records have been merged."
    redirect_to @keeper
  end
  
  def export_vcard
    card = @person.to_vcard
    filename = @person.full_name.gsub(" ", "").underscore + ".vcf"
    send_data @person.to_vcard, filename: "filename.vcf", disposition: "attachment"
  end
  
  def filter_attendances
    
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end
    
    def new_person
      @person = Person.new(person_params)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:household_id, :last_name, :first_name, :gender, :birthdate, :household_position, :allergies, :default_group_id,
                                     :image, :image_cache, :facebook_url)
    end
end
