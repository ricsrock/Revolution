class FollowUpsController < ApplicationController
  before_filter :authenticate_user!
  
  respond_to :html, :js
  before_action :set_follow_up, only: [:show, :edit, :update, :destroy]

  # GET /follow_ups
  # GET /follow_ups.json
  def index
    @follow_ups = FollowUp.all
  end

  # GET /follow_ups/1
  # GET /follow_ups/1.json
  def show
  end

  # GET /follow_ups/new
  def new
    @follow_up = FollowUp.new(contact_id: params[:contact_id])
    @contact = Contact.find(params[:contact_id])
  end

  # GET /follow_ups/1/edit
  def edit
  end

  # POST /follow_ups
  # POST /follow_ups.json
  def create
    @follow_up = FollowUp.new(follow_up_params)
    if @follow_up.save
      flash[:notice] = "New Follow-Up successfully added."
      @contact = @follow_up.contact
      if params[:follow_up][:close] == "1"
        logger.info "Set to close"
        if params[:follow_up][:transfer_user_id].blank?
          logger.info "transfer user is blank"
          @contact.close!
        end
      else
        logger.info "not set to close"
        @contact.in_progress!
      end
      if ! params[:follow_up][:transfer_user_id].blank?
        logger.info "transfer user is not blank --- calling transfer!"
        @contact.transfer!(params[:follow_up][:transfer_user_id], @follow_up.id)
      end
    end
    respond_with( @follow_up, layout: !request.xhr? )
  end

  # PATCH/PUT /follow_ups/1
  # PATCH/PUT /follow_ups/1.json
  def update
    respond_to do |format|
      if @follow_up.update(follow_up_params)
        format.html { redirect_to @follow_up, notice: 'Follow up was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @follow_up.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /follow_ups/1
  # DELETE /follow_ups/1.json
  def destroy
    @follow_up.destroy
    respond_to do |format|
      format.html { redirect_to follow_ups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_follow_up
      @follow_up = FollowUp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def follow_up_params
      params.require(:follow_up).permit(:notes, :contact_id, :created_by, :updated_by, :follow_up_type_id, :close, :transfer, :transfer_user_id)
    end
end
