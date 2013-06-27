class ContactFormsController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_contact_form, only: [:show, :edit, :update, :destroy]

  # GET /contact_forms
  # GET /contact_forms.json
  def index
    @contact_forms = ContactForm.all
  end

  # GET /contact_forms/1
  # GET /contact_forms/1.json
  def show
  end

  # GET /contact_forms/new
  def new
    @contact_form = ContactForm.new
  end

  # GET /contact_forms/1/edit
  def edit
  end

  # POST /contact_forms
  # POST /contact_forms.json
  def create
    @contact_form = ContactForm.new(contact_form_params)

    respond_to do |format|
      if @contact_form.save
        format.html { redirect_to @contact_form, notice: 'Contact form was successfully created.' }
        format.json { render action: 'show', status: :created, location: @contact_form }
      else
        format.html { render action: 'new' }
        format.json { render json: @contact_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contact_forms/1
  # PATCH/PUT /contact_forms/1.json
  def update
    respond_to do |format|
      if @contact_form.update(contact_form_params)
        format.html { redirect_to @contact_form, notice: 'Contact form was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @contact_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contact_forms/1
  # DELETE /contact_forms/1.json
  def destroy
    @contact_form.destroy
    respond_to do |format|
      format.html { redirect_to contact_forms_url }
      format.json { head :no_content }
    end
  end
  
  def add_contact_type_to
    @contact_type = ContactType.find(params[:id])
    @contact_form = ContactForm.find(params[:contact_form_id])
    @contact_form.contact_types << @contact_type
  end
  
  def remove_contact_type_from
    @contact_type = ContactType.find(params[:id])
    @contact_form = ContactForm.find(params[:contact_form_id])
    @contact_form.contact_types.delete(@contact_type)
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact_form
      @contact_form = ContactForm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_form_params
      params.require(:contact_form).permit(:name)
    end
end
