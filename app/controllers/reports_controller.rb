class ReportsController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  authorize_resource

  # GET /reports
  # GET /reports.json
  def index
    @q = Report.accessible_to_user(current_user.id).page(params[:page]).search(params[:q])
    @q.sorts = "name asc"
    @reports = @q.result(distinct: true)
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @p = Contact.fix_params(YAML::load(@report.parameters))
    #@q = Tagging.search(@q) --- how do I knwo the model?
    @q = @report.model_name.constantize.magic_includes.search(@p)
    @objects = @q.result(distinct: true)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = ReportPdf.new(@report, view_context, @objects)
        filename = @report.name.parameterize.underscore + ".pdf"
        send_data pdf.render, filename: filename,
                              type: "application/pdf",
                              disposition: "attachment"
      end
    end
  end

  # GET /reports/new
  def new
    @report = Report.new(range: params[:range])
    @search_params = YAML::dump(params[:parameters])
    @range = params[:range]
    @record_type = RecordType.find_by_name(params[:record_type])
    @record_type_id = @record_type.id
    @group_bys = @record_type.group_bys
    @layouts = @record_type.layouts
  end

  # GET /reports/1/edit
  def edit
    @search_params = @report.parameters
    @record_type = @report.record_type
    @record_type_id = @record_type.id
    @group_bys = @record_type.group_bys
    @layouts = @record_type.layouts
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.json { render action: 'show', status: :created, location: @report }
      else
        format.html { render action: 'new' }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url }
      format.json { head :no_content }
    end
  end
  
  def auto_contacts
    Person.create_auto_contacts
    Person.create_advance_decline_tags
    flash[:notice] = "AutoContacts and Advance/Decline Tags have been created successfully."
    redirect_to root_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:name, :record_type_id, :group_by_id, :layout_id, :parameters, :layout, :created_by, :updated_by, :range)
    end
end
