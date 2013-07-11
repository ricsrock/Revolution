class SmartGroupsController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_smart_group, only: [:show, :edit, :update, :destroy, :export, :export_by_household, :sms,
                                         :mass_contact, :sign_in_sheet_for, :export_vcards]

  # GET /smart_groups
  # GET /smart_groups.json
  def index
    # params[:q] = SmartGroup.fix_params(params[:q]) if params[:q]
    if ! params[:q]
      f = {q: {favorites_eq: "1"}}
      params.merge!(f)
    end
    @q = SmartGroup
    if params[:q] && params[:q][:favorites_eq] == "1"
      @q = SmartGroup.favorites_for(current_user)
    end
    @q = @q.page(params[:page]).search(params[:q])
    @smart_groups = @q.result
    @params = params[:q] if params[:q]
  end

  # GET /smart_groups/1
  # GET /smart_groups/1.json
  def show
    respond_to do |format|
      format.html
      format.pdf do
        pdf = SmartGroupPdf.new(@smart_group, view_context)
        filename = @smart_group.name.downcase.gsub(/[^0-9a-z]/, "_") + ".pdf"
        send_data pdf.render, filename: filename,
                              type: "application/pdf",
                              disposition: "attachment"
      end
    end
  end
  
  def sign_in_sheet_for
    respond_to do |format|
      format.html
      format.pdf do
        pdf = SignInSheetPdf.new(@smart_group, view_context)
        filename = @smart_group.name.downcase.gsub(/[^0-9a-z]/, "_") + ".pdf"
        send_data pdf.render, filename: filename,
                              type: "application/pdf",
                              disposition: "attachment"
      end
    end
  end
  
  def export
    filename = @smart_group.name.downcase.gsub(/[^0-9a-z]/, "_") + ".csv"
    send_data Person.to_csv(@smart_group.result), type: "text/csv", filename: filename
  end
  
  def export_by_household
    filename = @smart_group.name.downcase.gsub(/[^0-9a-z]/, "_") + "_households" + ".csv"
    send_data Person.to_households_csv(@smart_group.result.group('people.household_id')), filename: filename
  end
  
  def export_vcards
    batch_of_cards = ''
    @smart_group.result.each do |person|
      batch_of_cards << person.to_vcard if person.to_vcard
    end
    send_data batch_of_cards, :filename => @smart_group.name.downcase.gsub(/[^0-9a-z]/, "_") + "_vcards" + ".vcf"
  end
  
  
  
  # GET /smart_groups/new
  def new
    @smart_group = SmartGroup.new
  end

  # GET /smart_groups/1/edit
  def edit
  end

  # POST /smart_groups
  # POST /smart_groups.json
  def create
    @smart_group = SmartGroup.new(smart_group_params)

    respond_to do |format|
      if @smart_group.save
        format.html { redirect_to @smart_group, notice: 'Smart group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @smart_group }
      else
        flash[:alert] = "There were errors: #{@smart_group.errors.full_messages.to_sentence}"
        format.html { render action: 'new' }
        format.json { render json: @smart_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /smart_groups/1
  # PATCH/PUT /smart_groups/1.json
  def update
    respond_to do |format|
      if @smart_group.update(smart_group_params)
        format.html { redirect_to @smart_group, notice: 'Smart group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @smart_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /smart_groups/1
  # DELETE /smart_groups/1.json
  def destroy
    @smart_group.destroy
    respond_to do |format|
      format.html { redirect_to smart_groups_url }
      format.json { head :no_content }
    end
  end
  
  def property_selected
    @property = SmartGroupProperty.find(params[:property_id])
    @partial_name = @property.short + "_fields"
    @id = params[:object_id]
    @operators = @property.operators
    # @smart_group = SmartGroup.new
    # SimpleForm::FormBuilder.new(:smart_group, @smart_group, view_context, {}) do |f|
    #   f.simple_fields_for(:smart_group_rules, SmartGroupRule.new, child_index: params[:object_id]) do |rule_form|
    #     @form = rule_form
    #   end
    # end
    @smart_group_form = SimpleForm::FormBuilder.new(:smart_group, SmartGroup.new, view_context, {}, proc{})
  end
  
  def sms
    @message = Message.new
  end
  
  def mass_contact
    user_session[:return_to] = request.referer
    @contact = Contact.new
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_smart_group
      @smart_group = SmartGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def smart_group_params
      params[:smart_group][:smart_group_rules_attributes].each_value do |rule|
        rule[:content] = rule[:content] + ' !' + rule[:extra] if rule[:extra]
      end
      params.require(:smart_group).permit(:id, :name, :definition,
                                          smart_group_rules_attributes: [:id, :smart_group_id, :content, :property_id, :operator_id, :_destroy])
    end
end
