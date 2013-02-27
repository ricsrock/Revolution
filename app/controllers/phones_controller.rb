class PhonesController < ApplicationController
  respond_to :html, :js
  before_action :set_phone, only: [:show, :edit, :update, :destroy]

  # GET /phones
  # GET /phones.json
  def index
    @phones = Phone.all
  end

  # GET /phones/1
  # GET /phones/1.json
  def show
  end

  # GET /phones/new
  def new
    @phone = Phone.new(phonable_type: params[:phonable_type],
                       phonable_id: params[:phonable_id])
  end

  # GET /phones/1/edit
  def edit
    @phonable_type = @phone.phonable_type
    @phonable_id = @phone.phonable_id
  end

  # POST /phones
  # POST /phones.json
  def create
    @phone = Phone.new(phone_params)
    if @phone.save
      flash[:notice] = "New phone successfully added."
      @object = @phone.phonable
    end
    respond_with( @phone, layout: !request.xhr? )
  end

  # PATCH/PUT /phones/1
  # PATCH/PUT /phones/1.json
  def update
    if @phone.update(phone_params)
      flash[:notice] = "Phone was successfully updated."
      @object = @phone.phonable
    end
    respond_with( @phone, layout: !request.xhr? )
  end

  # DELETE /phones/1
  # DELETE /phones/1.json
  def destroy
    @go_to = @phone.phonable
    if @phone.destroy
      flash[:notice] = "Phone was destroyed forever."
      respond_to do |format|
        format.html { redirect_to @go_to }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_phone
      @phone = Phone.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def phone_params
      params.require(:phone).permit(:phonable_type, :phonable_id, :number, :primary, :comments)
    end
end
