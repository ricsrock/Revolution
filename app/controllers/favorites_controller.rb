class FavoritesController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_favorite, only: [:show, :edit, :update, :destroy]

  # GET /favorites
  # GET /favorites.json
  def index
    @favorites = Favorite.all
  end

  # GET /favorites/1
  # GET /favorites/1.json
  def show
  end

  # GET /favorites/new
  def new
    @favorite = Favorite.new
  end

  # GET /favorites/1/edit
  def edit
  end

  # POST /favorites
  # POST /favorites.json
  def create
    @favorite = Favorite.new(favorite_params)

    respond_to do |format|
      if @favorite.save
        format.html { redirect_to @favorite, notice: 'Favorite was successfully created.' }
        format.json { render action: 'show', status: :created, location: @favorite }
      else
        format.html { render action: 'new' }
        format.json { render json: @favorite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /favorites/1
  # PATCH/PUT /favorites/1.json
  def update
    respond_to do |format|
      if @favorite.update(favorite_params)
        format.html { redirect_to @favorite, notice: 'Favorite was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @favorite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /favorites/1
  # DELETE /favorites/1.json
  def destroy
    @favorite.destroy
    respond_to do |format|
      format.html { redirect_to favorites_url }
      format.json { head :no_content }
    end
  end
  
  def add_to
    object = params[:klass].constantize.find(params[:id])
    if current_user.favorite(object)
      flash[:notice] = "Favorite added"
    else
      flash[:alert] = "Already in favorites"
    end
    redirect_to :back
  end
  
  def remove_from
    object = params[:klass].constantize.find(params[:id])
    if current_user.unfavorite(object)
      flash[:notice] = "Favorite removed"
    else
      flash[:alert] = "Could not be removed from favorites"
    end
    redirect_to :back
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_favorite
      @favorite = Favorite.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def favorite_params
      params.require(:favorite).permit(:favoritable, :belongs_to)
    end
end
