class TagGroupsController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_tag_group, only: [:show, :edit, :update, :destroy]

  # GET /tag_groups
  # GET /tag_groups.json
  def index
    @tag_groups = TagGroup.all
  end

  # GET /tag_groups/1
  # GET /tag_groups/1.json
  def show
  end

  # GET /tag_groups/new
  def new
    @tag_group = TagGroup.new
  end

  # GET /tag_groups/1/edit
  def edit
  end

  # POST /tag_groups
  # POST /tag_groups.json
  def create
    @tag_group = TagGroup.new(tag_group_params)

    respond_to do |format|
      if @tag_group.save
        format.html { redirect_to @tag_group, notice: 'Tag group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @tag_group }
      else
        format.html { render action: 'new' }
        format.json { render json: @tag_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tag_groups/1
  # PATCH/PUT /tag_groups/1.json
  def update
    respond_to do |format|
      if @tag_group.update(tag_group_params)
        format.html { redirect_to @tag_group, notice: 'Tag group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tag_group.errors, status: :unprocessable_entity }
      end      
    end
  end

  # DELETE /tag_groups/1
  # DELETE /tag_groups/1.json
  def destroy
    @tag_group.destroy
    respond_to do |format|
      format.html { redirect_to tag_groups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag_group
      @tag_group = TagGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_group_params
      params.require(:tag_group).permit(:name, tags_attributes: [:name, :id, :_destroy])
    end
end
