class ContributionsController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource
  before_action :set_contribution, only: [:show, :edit, :update, :destroy]
  respond_to :html, :js

  # GET /contributions
  # GET /contributions.json
  def index
    @contributions = Contribution.all
  end

  # GET /contributions/1
  # GET /contributions/1.json
  def show
  end

  # GET /contributions/new
  def new
    @contribution = Contribution.new
  end

  # GET /contributions/1/edit
  def edit
  end

  # POST /contributions
  # POST /contributions.json
  def create
    @contribution = Contribution.new(contribution_params)
    @batch_id = @contribution.batch_id
    if @contribution.save
      flash[:notice] = "Contribution was successfully created."
      @batch = @contribution.batch
      @contribution = Contribution.new
    else
      @person = Person.find(params[:contribution][:person_id]) if params[:contribution][:person_id]
      @form = ActionView::Helpers::FormBuilder.new(:contribution, @contribution, view_context, {}, proc{})
      flash[:alert] = "Contribution could not be saved. Errors: #{@contribution.errors.full_messages {|m|}.to_sentence}. Please try again."
    end
    respond_with( @contribution, layout: !request.xhr? )
    
    # respond_to do |format|
    #   if @contribution.save
    #     format.html { redirect_to enter_contributions_path(batch_id: @contribution.batch_id), notice: 'Contribution was successfully created.' }
    #     format.json { render action: 'show', status: :created, location: @contribution }
    #   else
    #     format.html { render action: 'enter' }
    #     format.json { render json: @contribution.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /contributions/1
  # PATCH/PUT /contributions/1.json
  def update
    respond_to do |format|
      if @contribution.update(contribution_params)
        format.html { redirect_to @contribution, notice: 'Contribution was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contributions/1
  # DELETE /contributions/1.json
  def destroy
    if @contribution.destroy
      flash[:notice] = "Contribution was successfully destroyed."
    else
      flash[:notice] = "Contribution could not be destroyed."
    end
    respond_to do |format|
      format.html { redirect_to enter_contributions_path(batch_id: params[:batch_id]) }
      format.json { head :no_content }
    end
  end
  
  def enter
    @batch = Batch.find(params[:batch_id])
    @contribution = Contribution.new
  end
  
  def find_person
    @object_id = params[:object_id]
    @results = []
  end
  
  def search_person
    q = params[:q].split(',')
    @results = []
    if q.length == 1
      term = "%" + params[:q] + "%"
      Person.where('first_name LIKE ? OR last_name LIKE ?', term, term).limit(10).order('last_name ASC, first_name ASC').each { |p| @results << p }
    else
      term1 = "%" + q.first.strip + "%"
      term2 = "%" + q.last.strip + "%"
      Person.where('first_name LIKE ? AND last_name LIKE ?', term2, term1).limit(10).order('last_name ASC, first_name ASC').each { |p| @results << p }
    end
    Organization.where('name LIKE ?', term).limit(5).order('name ASC').each { |o| @results << o }
  end
  
  def choose_person
    @class_name = params[:contributor_class]
    @contributor = @class_name.constantize.find(params[:contributor_id])
    @contribution = Contribution.new
    @form = ActionView::Helpers::FormBuilder.new(:contribution, @contribution, view_context, {}, proc{})
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contribution
      @contribution = Contribution.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contribution_params
      params.require(:contribution).permit(:id, :contributable_id, :contributable_type, :date, :check_num, :batch_id,
                                            donations_attributes: [:amount, :fund_id])
    end
end
