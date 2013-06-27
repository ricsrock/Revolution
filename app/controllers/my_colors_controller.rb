class MyColorsController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_my_color, only: [:show, :edit, :update, :destroy]

  # GET /my_colors
  # GET /my_colors.json
  def index
    @my_colors = MyColor.all
  end

  # GET /my_colors/1
  # GET /my_colors/1.json
  def show
  end

  # GET /my_colors/new
  def new
    @my_color = MyColor.new
  end

  # GET /my_colors/1/edit
  def edit
  end

  # POST /my_colors
  # POST /my_colors.json
  def create
    @my_color = MyColor.new(my_color_params)

    respond_to do |format|
      if @my_color.save
        format.html { redirect_to @my_color, notice: 'My color was successfully created.' }
        format.json { render action: 'show', status: :created, location: @my_color }
      else
        format.html { render action: 'new' }
        format.json { render json: @my_color.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /my_colors/1
  # PATCH/PUT /my_colors/1.json
  def update
    respond_to do |format|
      if @my_color.update(my_color_params)
        format.html { redirect_to @my_color, notice: 'My color was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @my_color.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /my_colors/1
  # DELETE /my_colors/1.json
  def destroy
    @my_color.destroy
    respond_to do |format|
      format.html { redirect_to my_colors_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_my_color
      @my_color = MyColor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def my_color_params
      params.require(:my_color).permit(:name, :updated_by, :created_by)
    end
end
