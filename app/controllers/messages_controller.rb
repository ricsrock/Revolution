class MessagesController < ApplicationController
  before_filter :authenticate_user!, except: :receive
  
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, only: :receive
  
  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.roots.order('created_at DESC')
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        session[:user_id] = current_user.login
        session[:conversation_id] = @message.id
        send_message(@message)
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render action: 'show', status: :created, location: @message }
      else
        format.html { redirect_to :back, alert: "Try again. #{@message.errors.full_messages.to_sentence}" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end
  
  def receive
    # flash[:notice] = params[:Body]
    # if session[:user_id]
    #   puts "there's a cookie"
    # else
    #   puts "no cookie"
    # end
    # render action: :receive
    # session["counter"] ||= 0
    # session[:number] = params[:From]
    # sms_count = session["counter"]
    # if sms_count == 0
    #   message = "Hello, thanks for the new message."
    # else 
    #   message = "Hello, thanks for message number #{sms_count + 1} ID: #{session[:number]}"
    # end
    # twiml = Twilio::TwiML::Response.new do |r|
    #   r.Sms message
    # end
    # session["counter"] += 1
    # puts twiml.text
    # send_reply(params[:From], message)
    
    # see if this text is parse-able...
    @body = params[:Body]
    if @body.downcase.strip.starts_with?('checkin')
      session[:conversation_id] #||= params[:From]
      m = params[:Body]
      s = m.split(' ')
      data = s.last.split('-')
      send_response('+13186555808', "hi there, I see that you want to be checked in: #{data}")
    else
      # not parse-able. Assume it's a response to a previous message...
      logger.info "conversation id: #{session[:conversation_id]}"
      child_number = params[:From]
      parent_message = Message.where('recipients.number LIKE ?', child_number).joins(:recipients).order('messages.created_at DESC').first
      if parent_message
        session[:conversation_id] ||= parent_message.id
        #message_attributes = {from: params[:From], body: params[:Body]}
        # reply_to.add_child_and_notify(message_attributes)
        child_message = parent_message.children.create(from: child_number, body: params[:Body])
        #set recipients of child_message... sender of parent_message
        #number = child_message.sender
        child_person = Person.where('phones.number = ?', child_number[-10..-1]).joins(:phones).first
        child_message.recipients << Recipient.create(person_id: parent_message.from_person.id, number: parent_message.sender)
      
        #notify the sender of the parent message...
        send_notification(parent_message.sender, child_message.body, child_person)
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params[:message][:user_id] = current_user.id
      params[:message][:from] = "+13183034399"
      params.require(:message).permit!
    end
    
    def send_message(message)
      @account_sid = CONFIG[:twilio_account_sid]
      @auth_token = CONFIG[:twilio_auth_token]
      @client = Twilio::REST::Client.new @account_sid, @auth_token
      from = "+13183034399"
      @recipients = []
      message.recipients.each do |r|
        @recipients << r.number
      end
      session[:user_id]
      @recipients.each do |number|
        @client.account.sms.messages.create(
            :from => from,
            :to => number,
            :body => message.body
          )
        end
    end
    
    def send_response(to, body)
      @account_sid = CONFIG[:twilio_account_sid]
      @auth_token = CONFIG[:twilio_auth_token]
      @client = Twilio::REST::Client.new @account_sid, @auth_token
      from = "+13183034399"
      @client.account.sms.messages.create(
          :from => from,
          :to => to,
          :body => body
        )
    end
    
    def send_notification(to, body, from_person)
      @account_sid = CONFIG[:twilio_account_sid]
      @auth_token = CONFIG[:twilio_auth_token]
      @client = Twilio::REST::Client.new @account_sid, @auth_token
      from = "+13183034399"
      @client.account.sms.messages.create(
          :from => from,
          :to => to,
          :body => "You have a reply from #{from_person.full_name} #{from_person.mobile_number}: " + body + " conversation id: #{session[:conversation_id]}"
        )
    end
end
