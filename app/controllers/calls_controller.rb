class CallsController < ApplicationController
  before_action :set_call, only: [:show, :edit, :update, :destroy]

  # GET /calls
  def index
    @calls = Call.all
  end

  # GET /calls/1
  def show
  end

  # GET /calls/new
  def new
    @call = Call.new
  end

  # GET /calls/1/edit
  def edit
  end

  # POST /calls
  def create
    @call = Call.new(call_params)

    if @call.save
      redirect_to @call, notice: 'Call was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /calls/1
  def update
    if @call.update(call_params)
      redirect_to @call, notice: 'Call was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /calls/1
  def destroy
    @call.destroy
    redirect_to calls_url, notice: 'Call was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_call
      @call = Call.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def call_params
      params.require(:call).permit(:from, :to, :sid, :rec_sid, :rec_url, :rec_duration, :for_user_id)
    end
end
