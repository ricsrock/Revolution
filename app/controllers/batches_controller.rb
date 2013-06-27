class BatchesController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource
  before_action :set_batch, only: [:show, :edit, :update, :destroy, :breakout]

  # GET /batches
  # GET /batches.json
  def index
    params[:q] = Batch.fix_params(params[:q]) if params[:q]
    @q = Batch.page(params[:page]).search(params[:q])
    # @q.range_selector_cont ||= "Last 13 Weeks"
    @q.sorts = "date_collected desc" if @q.sorts.empty?
    @range = params[:q][:range_selector_cont] if params[:q]
    @batches = @q.result(:distinct => true)
  end

  # GET /batches/1
  # GET /batches/1.json
  def show
    respond_to do |format|
      format.html
      format.pdf do
        pdf = BatchPdf.new(@batch, view_context)
        filename = @batch.date_collected.to_s.gsub(/[^0-9a-z]/, "_") + "_batch" + ".pdf"
        send_data pdf.render, filename: filename,
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def breakout
    respond_to do |format|
      format.html
      format.pdf do
        pdf = BatchBreakoutPdf.new(@batch, view_context)
        filename = @batch.date_collected.to_s.gsub(/[^0-9a-z]/, "_") + "_batch_breakout" + ".pdf"
        send_data pdf.render, filename: filename,
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  # GET /batches/new
  def new
    @batch = Batch.new
  end

  # GET /batches/1/edit
  def edit
  end

  # POST /batches
  # POST /batches.json
  def create
    @batch = Batch.new(batch_params)

    respond_to do |format|
      if @batch.save
        format.html { redirect_to @batch, notice: 'Batch was successfully created.' }
        format.json { render action: 'show', status: :created, location: @batch }
      else
        format.html { render action: 'new' }
        format.json { render json: @batch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /batches/1
  # PATCH/PUT /batches/1.json
  def update
    respond_to do |format|
      if @batch.update(batch_params)
        format.html { redirect_to @batch, notice: 'Batch was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @batch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /batches/1
  # DELETE /batches/1.json
  def destroy
    @batch.destroy
    respond_to do |format|
      format.html { redirect_to batches_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_batch
      @batch = Batch.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def batch_params
      params.require(:batch).permit(:id, :date_collected, :count_total, :contributions_num, :comments)
    end
end
