class SignUpsController < ApplicationController
  before_action :set_sign_up, only: [:show, :edit, :update, :destroy]

  # GET /sign_ups
  def index
    @sign_ups = SignUp.all
    session[:sign_up_step] = session[:sign_up_params] = nil
  end

  # GET /sign_ups/1
  def show
  end

  # GET /sign_ups/new
  def new
    session[:sign_up_params] ||= {}
    @sign_up = SignUp.new(session[:sign_up_params])
    logger.info "--------- session[:sign_up_params]: #{session[:sign_up_params]} -------------"
    @sign_up.current_step = session[:sign_up_step]
    # session[:sign_up_step] = nil
    session[:meeting_id] = params[:meeting_id]
    if @sign_up.current_step == 'phone'
      @pad = 'num_pad'
    else
      @pad = 'alpha_keyboard'
    end
  end

  # GET /sign_ups/1/edit
  def edit
  end

  # POST /sign_ups
  def create
    session[:sign_up_params].merge!(params[:sign_up]) if params[:sign_up]
    logger.info "session[:sign_up_params] after deep merge: #{session[:sign_up_params]}"
    @sign_up = SignUp.new(session[:sign_up_params])
    @sign_up.current_step = session[:sign_up_step]
    logger.info "@sign_up.valid?: #{@sign_up.valid?}"
    logger.info "current_step: #{@sign_up.current_step}"
    if @sign_up.valid?
      if params[:back_button]
        @sign_up.previous_step
      elsif @sign_up.last_step?
        @sign_up.save if @sign_up.all_valid?
      else
        logger.info "current_step: #{@sign_up.current_step}"
        @sign_up.next_step
        logger.info "current_step: #{@sign_up.current_step}"
      end
      session[:sign_up_step] = @sign_up.current_step
      logger.info "SignUp new_record?: #{@sign_up.new_record?}"
    end
    if @sign_up.current_step == 'phone'
      @pad = 'num_pad'
    else
      @pad = 'alpha_keyboard'
    end
    if @sign_up.new_record?
      render "new"
    else
      logger.info "------- NOT A NEW RECORD! ----------"
      session[:sign_up_step] = session[:sign_up_params] = nil
      flash[:notice] = "SignUp complete! You may now Check-In!"
      @meeting = Meeting.find(session[:meeting_id])
      @redirect_path = kiosk_meeting_path(@meeting)
      person = Person.stubb(@sign_up, @meeting)
      person.enroll!(@meeting.group)
      session[:meeting_id] = nil
    end
  end

  # PATCH/PUT /sign_ups/1
  def update
    session[:sign_up_params].deep_merge!(params[:sign_up]) if params[:sign_up]
    @sign_up = SignUp.new(session[:sign_up_params])
    
    if @sign_up.valid?
      if params[:back_button]
        @sign_up.previous_step
      elsif @sign_up.last_step?
        @sign_up.save if @sign_up.last_step? && @sign_up.all_valid?
      else
        @sign_up.next_step
      end
      session[:sign_up_step] = @sign_up.current_step
      if @sign_up.new_record?
        logger.info "SignUp new_record?: #{@sign_up.new_record?}"
        render "new"
      else
        session[:sign_up_step] = session[:sign_up_params] = nil
        flash[:notice] = "SignUp complete! You may now Check-In!"
        redirect_to @sign_up #this should point to the referring meeting...
      end
    end
    # if @sign_up.update(sign_up_params)
    #   redirect_to @sign_up, notice: 'Sign up was successfully updated.'
    # else
    #   render action: 'new'
    # end
  end

  # DELETE /sign_ups/1
  def destroy
    @sign_up.destroy
    redirect_to sign_ups_url, notice: 'Sign up was successfully destroyed.'
  end
  
  def key_pressed
    @sign_up = SignUp.new(session[:sign_up_params])
    logger.info "current_step: #{@sign_up.current_step}"
    @sign_up.current_step = session[:sign_up_step]
    @attr = @sign_up.current_step
    @sign_up.read_attribute(@attr).nil? ? @term = "" : @term = @sign_up.read_attribute(@attr)
    # @term ||= " "
    if params[:key] == "Backspace" or params[:key] == "<"
      @term = @term.chop
    elsif params[:key] == "Clear"
      @term = ""
    else
      logger.info "------ adding params[:key] to @term: #{params[:key]} ---------"
      @term = @term << params[:key]
    end
    @sign_up.send(:write_attribute, @attr, @term)
    session[:sign_up_params].merge!(@attr => @term)
    logger.info "--------- session[:sign_up_params]: #{session[:sign_up_params]} -------------"
    @form = SimpleForm::FormBuilder.new(:sign_up, @sign_up, view_context, {}, proc{})
    @partial = @sign_up.current_step + '_step'
  end
  
  def cancel
    @meeting = Meeting.find(session[:meeting_id])
    session[:meeting_id] = nil
    redirect_to kiosk_meeting_path(@meeting)
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sign_up
      @sign_up = SignUp.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sign_up_params
      params.require(:sign_up).permit(:first_name, :last_name, :gender, :phone, :step, :id)
    end
end
