class ContactsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_admin, :only => :index
  before_filter :verify_confidential_permission, only: [:show]
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  
  load_and_authorize_resource
  skip_load_and_authorize_resource only: [:new, :create]

  # GET /contacts
  # GET /contacts.json
  def index
    @range = params[:q][:range_selector_cont] if params[:q]
    params[:q] = Contact.fix_params(params[:q]) if params[:q]
    # params[:q][:person_last_name_or_person_first_name_cont_any] = params[:q][:person_last_name_or_person_first_name_cont_any].split(' ') if params[:q] && params[:q][:person_last_name_or_person_first_name_cont_any]
    @q = Contact.page(params[:page]).includes(:responsible_user, :contact_type, :contactable).search(params[:q])
    @contacts = @q.result(:distinct => true)
    @search_params = params[:q] if params[:q].present? #&& params[:q][:tag_tag_group_id_eq].present?
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    # @contact = Contact.new
    @contacts = []
    @clazz = params[:contactable_type]
    @contactable = @clazz.constantize.find(params[:contactable_id]) if @clazz
    ContactForm.first.contact_types.active.each do |contact_type|
      @contacts << Contact.new(contactable_id: @contactable.try(:id), contactable_type: @contactable.class ? @contactable.class.name : false, contact_type_id: contact_type.id)
    end
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        format.json { render action: 'show', status: :created, location: @contact }
      else
        format.html { render action: 'new' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def create_multiple
    @clazz = params[:contactable_type]
    @contactable = @clazz.constantize.find(params[:contactable_id]) if @clazz
    number_saved = 0
    contacts = params[:contacts]
    contacts.each_value do |attributes|
      if attributes[:included] == "1"
        contact = Contact.new(attributes.except!(:included))
        if contact.save!
          number_saved += 1
        end
      end
    end
    flash[:notice] = "#{number_saved} contacts were successfully created."
    redirect_to @contactable || root_url
  end
  
  def mass_create
    @smart_group = SmartGroup.find(params[:smart_group_id])
    if ! params[:contact][:mass_recipients]
      @go_to = :back
      flash[:error] = "You didn't select any people. Don't play me."
    else
      person_ids = params[:contact][:mass_recipients]
      counter = 0
      person_ids.each do |id|
        @contact = Contact.new(contact_type_id: params[:contact][:contact_type_id],
                               comments: params[:contact][:comments])
        @contact.contactable_id = id
        @contact.contactable_type = 'Person'
        if @contact.contact_type_id && @contact.save
          counter += 1
        end
      end
      flash[:notice] = "#{counter} contacts were successfully created."
    end
    redirect_to @go_to || user_session[:return_to] || smart_groups_url
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.json { head :no_content }
    end
  end
  
  def filter
    @contact_form = ContactForm.find(params[:contact_form_selector])
    @clazz = params[:contactable_type]
    @contactable = @clazz.constantize.find(params[:contactable_id]) if @clazz
    @contacts = []
    @contact_form.contact_types.active.each {|c| @contacts << Contact.new(contactable_id: @contactable.try(:id), contactable_type: @contactable.class.name, contact_type_id: c.id)}
  end
  
  def manage
    params[:q] = Contact.fix_params(params[:q]) if params[:q]
    @q = Contact.for_user(current_user.id).search(params[:q])
    @contacts = @q.result(distinct: true)
  end
  
  def act_on_multiple
    p = params[:contact]
    if p[:selected_ids]
      action_chosen = p[:choice]
      case action_chosen
      when "Multi-Close"
        action_to_take = "multi_close"
      when "Export"
        action_to_take = "export"
      when "Transfer Multiple"
        action_to_take = "multi_transfer"
      else
        action_to_take = "unknown"
      end
      @partial = action_to_take
      @contact_ids = p[:selected_ids]
    else
      flash[:alert] = "You didn't select any contacts, silly goose!"
      redirect_to manage_contacts_path
    end
  end
  
  def multi_close
    ids = params[:contact_ids]
    counter = 0
    ids.each do |id|
      contact = Contact.find(id)
      follow_up = FollowUp.new(follow_up_type_id: params[:follow_up][:follow_up_type_id],
                               notes: params[:follow_up][:notes] + ' (closed by multi-close)')
      follow_up.contact_id = id
      if follow_up.save
        if contact.close!
          counter += 1
        end
      end
    end
    flash[:notice] = "#{counter} contacts successfully closed."
    redirect_to manage_contacts_path
  end
  
  def multi_transfer
    ids = params[:contact_ids]
    counter = 0
    ids.each do |id|
      contact = Contact.find(id)
      follow_up = FollowUp.new(follow_up_type_id: params[:follow_up][:follow_up_type_id],
                               notes: params[:follow_up][:notes] + ' (transferred by multi-transfer)')
      follow_up.contact_id = id
      if follow_up.save
        if contact.transfer!(params[:follow_up][:transfer_user_id], follow_up.id)
          counter += 1
        end
      end
    end
    flash[:notice] = "#{counter} contacts successfully transferred."
    redirect_to manage_contacts_path
  end
  
  
  def export
    contacts = []
    params[:contact_ids].each do |id|
      contacts << Contact.find(id)
    end
    send_data Contact.to_csv(contacts), disposition: :attachment, filename: "contacts.csv"
  end
  
  def new_quick
    @contact = Contact.new(contact_type_id: params[:contact_type_id])
    @contact_type = ContactType.find(params[:contact_type_id])
    @person = Person.find(params[:person_id])
  end
  
  def create_quick
    @contact = Contact.new(contact_params)
    @contact.responsible_user_id = current_user.id
    if @contact.save
      @contact.follow_ups.create(notes: @contact.comments + ' (created by quick contact)', follow_up_type_id: @contact.contact_type.default_follow_up_type_id)
      @contact.close!
      flash[:notice] = "Quick contact successfully created!"
    else
      flash[:alert] = "The contact could not be created. Try again."
    end
    redirect_to person_path(@contact.contactable)
  end
  
  def popup
    @contact = Contact.find(params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:contact_type_id, :contactable_id, :contactable_type, :responsible_user_id, :comments, :included, :mass_recipients)
    end
    
    def verify_admin
      super
    end
    
    def verify_confidential_permission
      @contact = Contact.find(params[:id])
      raise CanCan::AccessDenied if ! current_user.can_access?(@contact)
    end
    
end
