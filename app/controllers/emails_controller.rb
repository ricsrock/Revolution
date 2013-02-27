class EmailsController < ApplicationController
  respond_to :html, :js
  before_action :set_email, only: [:show, :edit, :update, :destroy]
  
  # GET /emails
  # GET /emails.json
  def index
    @emails = Email.all
  end

  # GET /emails/1
  # GET /emails/1.json
  def show
  end

  # GET /emails/new
  def new
    @email = Email.new(emailable_type: params[:emailable_type],
                       emailable_id: params[:emailable_id])
  end

  # GET /emails/1/edit
  def edit
  end

  # POST /emails
  # POST /emails.json
  def create
    @email = Email.new(email_params)
    if @email.save
      flash[:notice] = "Email was successfully saved."
      @object = @email.emailable
    end
    respond_with( @email, layout: !request.xhr? )
  end

  # PATCH/PUT /emails/1
  # PATCH/PUT /emails/1.json
  def update
    if @email.update(email_params)
      flash[:notice] = "Email was successfully updated."
      @object = @email.emailable
    end
    respond_with( @email, layout: !request.xhr? )
  end

  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    @go_to = @email.emailable
    if @email.destroy
      flash[:notice] = "Email was destroyed forever."
      redirect_to @go_to
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email
      @email = Email.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_params
      params.require(:email).permit(:emailable_type, :emailable_id, :email, :comments, :primary)
    end
end
