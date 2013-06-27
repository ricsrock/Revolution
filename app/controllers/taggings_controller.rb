class TaggingsController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_tagging, only: [:show, :edit, :update, :destroy]
  respond_to :html, :js

  # GET /taggings
  # GET /taggings.json
  def index
    params[:q] = Tagging.fix_params(params[:q]) if params[:q]
    @q = Tagging.page(params[:page]).search(params[:q])
    @taggings = @q.result
    if params[:q].present? && params[:q][:tag_tag_group_id_eq].present?
      @tags = TagGroup.where(id: params[:q][:tag_tag_group_id_eq]).first.tags
      @form = SimpleForm::FormBuilder.new(:q, @q, view_context, {}, proc{})
    end
    @range = params[:q][:range_selector_cont] if params[:q]
    @search_params = params[:q] if params[:q].present? && params[:q][:tag_tag_group_id_eq].present?
  end

  # GET /taggings/1
  # GET /taggings/1.json
  def show
  end

  # GET /taggings/new
  def new
    @tagging = Tagging.new(person_id: params[:person_id])
    @person = Person.find(params[:person_id])
  end

  # GET /taggings/1/edit
  def edit
    @person = @tagging.person
  end

  # POST /taggings
  # POST /taggings.json
  def create
    @tagging = Tagging.new(tagging_params)

    if @tagging.save
      flash[:notice] = "Tag was successfully created"
      @person = @tagging.person
    else
      flash[:alert] = "There were errors: #{@tagging.errors.full_messages.to_sentence}"
    end
    respond_with( @tagging, layout: !request.xhr? )
  end

  # PATCH/PUT /taggings/1
  # PATCH/PUT /taggings/1.json
  def update
    if @tagging.update(tagging_params)
      flash[:notice] = 'Tagging was successfully updated.'
      @person = @tagging.person
    else
      flash[:alert] = "There were errors: #{@tagging.errors.full_messages.to_sentence}"
    end
    respond_with( @tagging, layout: !request.xhr?)
  end

  # DELETE /taggings/1
  # DELETE /taggings/1.json
  def destroy
    @person = @tagging.person
    if @tagging.destroy
      flash[:notice] = 'Tag was successfully destroyed forever'
    else
      flash[:alert] = 'Tag could not be destroyed'
    end
    respond_to do |format|
      format.html { redirect_to person_path(@person) }
      format.json { head :no_content }
    end
  end
  
  def tag_group_selected
    @tag_group = TagGroup.find(params[:tag_group_id])
    @tags = @tag_group.tags.order(:name)
    @g = Tagging.search
    @form = SimpleForm::FormBuilder.new(:q, @q, view_context, {}, proc{})
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tagging
      @tagging = Tagging.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tagging_params
      params.require(:tagging).permit(:id, :tag_group_id, :tag_id, :person_id, :_destroy, :start_date, :end_date, :comments)
    end
end
