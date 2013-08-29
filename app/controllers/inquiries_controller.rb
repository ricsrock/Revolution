class InquiriesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_inquiry, only: [:show, :edit, :update, :destroy]

  # GET /inquiries
  def index
    @q = Inquiry.page(params[:page]).search(params[:q])
    @inquiries = @q.result(distinct: true)
  end

  # GET /inquiries/1
  def show
  end

  # GET /inquiries/new
  def new
    # @inquiry = Inquiry.new
    @groups = SmallGroup.inquirable
    @person = Person.find(params[:person_id])
  end
  
  def new_by_group
    @group = Group.find(params[:id])
  end

  # GET /inquiries/1/edit
  def edit
  end

  # POST /inquiries
  def create
    @inquiry = Inquiry.new(inquiry_params)

    if @inquiry.save
      redirect_to @inquiry, notice: 'Inquiry was successfully created.'
    else
      render action: 'new'
    end
  end
  
  def create_multiple
    # @clazz = params[:contactable_type]
    # @contactable = @clazz.constantize.find(params[:contactable_id]) if @clazz
    person_id = params[:person_id]
    @person = Person.find(person_id)
    number_saved = 0
    groups = params[:groups]
    groups.each_value do |attributes|
      if attributes[:included] == "1"
        inquiry = Inquiry.new(person_id: person_id, group_id: attributes[:group_id])
        if inquiry.save!
          number_saved += 1
          InquiryMailer.notification(inquiry, current_user).deliver!
        end
      end
    end
    flash[:notice] = "#{number_saved} inquiries were successfully created."
    redirect_to @person || root_url
  end
  
  def create_by_group
    @group = Group.find(params[:group_id])
    people_ids = params[:included_people]
    counter = 0
    if people_ids
      people_ids.each do |id|
        inquiry = Inquiry.new(person_id: id, group_id: @group.id)
        if inquiry.save!
          counter += 1
          InquiryMailer.notification(inquiry, current_user).deliver! unless inquiry.person.best_email == 'no email'
        end
      end
    end
    if counter == 0
      flash[:error] = "No inquiries were created. Try again."
    else
      flash[:notice] = "#{counter} inquiries successfully created."
    end
    redirect_to @group.becomes(Group) || root_url
  end
  

  # PATCH/PUT /inquiries/1
  def update
    if @inquiry.update(inquiry_params)
      redirect_to @inquiry, notice: 'Inquiry was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /inquiries/1
  def destroy
    @inquiry.destroy
    redirect_to inquiries_url, notice: 'Inquiry was successfully destroyed.'
  end
  
  def notify_group_leaders
    @q = Inquiry.search(params[:q])
    @inquiries = @q.result(distinct: true)
    @grouped = @inquiries.group_by {|i, inquiries| i.group_id}
    @grouped.each do |group_id, inquiries|
      @group = Group.find(group_id)
      people_ids = inquiries.collect {|a| a.person_id}.uniq
      InquiryMailer.notify_group_leader(@group, people_ids, current_user).deliver! if @group.primary_leaderships.present?
    end
    redirect_to inquiries_url
  end
  
  def search_people
    term = params[:q]
    term.blank? ? term = 'xzxzxzxzxzxzxzxz' : term = term
    terms = term.split(' ')
    if terms.size > 1
      conditions = ['(first_name LIKE ? AND last_name LIKE ?) OR (last_name LIKE ? AND first_name LIKE ?)', "%#{terms.first}%", "%#{terms.last}%", "%#{terms.first}%", "%#{terms.last}%"]
    else
      conditions = ['first_name LIKE ? OR last_name LIKE ?', "%#{term}%", "%#{term}%"]
    end
    @results = Person.where(conditions).order('last_name, first_name ASC')
  end
  
  def include_person
    @person = Person.find(params[:person_id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inquiry
      @inquiry = Inquiry.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def inquiry_params
      params.require(:inquiry).permit(:person_id, :group_id, :created_by, :updated_by)
    end
end
