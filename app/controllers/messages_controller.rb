class MessagesController < ApplicationController
  before_filter :authenticate_user!, except: [:receive, :receive_call, :save_recording]
  
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, only: [:receive, :receive_call, :save_recording]
  
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
      # hey! We've got a parse-able text! Someone wants to checkin!
      session[:conversation_id] ||= params[:From]
      m = params[:Body]
      #s = m.split(' ')
      data = m.split(' ')
      meeting = Meeting.find_by_checkin_code(data.last.strip)
      # meeting#current specifies that the meeting must have a date that is within a 2-day window of now.
      # You can't text-checkin into far-past or far-future events.
      if meeting && meeting.current?
        person = Person.where('phones.number = ?', params[:From][-10..-1]).joins(:phones).first
        if person
          if person.enrolled_in_group?(meeting.group)
            # checkin this person!
            attendance = person.checkin(group_id: meeting.group.id, instance_id: meeting.instance.id)
            if attendance.persisted?
              body = "You've been successfully checked into #{attendance.group.name}!"
            else
              body = "Sorry. Couldn't check you in: #{attendance.errors.full_messages.to_sentence}"
            #body = "Meeting: #{meeting.group.name}, #{meeting.date}, person: #{person.full_name}, and you are enrolled in the group. Bingo!"
            end
          else
            body = "Meeting: #{meeting.group.name}, #{meeting.date}, person: #{person.full_name}, but you are not enrolled in the group."
          end
        else
          body = "Meeting: #{meeting.group.name}, #{meeting.date}, but we couldn't find a person matching your phone number."
        end
      else
        body = "It looks like you want to checkin to a meeting, but we couldn't find a valid meeting to match your message content."
      end
      send_response(params[:From], "Hi there! #{body}")
      
    # nothing parse-able...
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
  
  def receive_call
    @call = Call.create(from: params[:From], to: params[:To], sid: params[:CallSid])
    response = Twilio::TwiML.build do |res|
      res.say "Thanks for calling River Valley Church. I don't know what to do after this. Lowell will teach me something cool very soon. Leave a message."
      res.record action: 'save_recording', method: :get
    end
    render text: response, content_type: 'application/xml'
  end
  
  def save_recording
    @call = Call.find_by_sid(params[:CallSid])
    @call.update_attributes(rec_sid: params[:RecordingSid], rec_url: params[:RecordingUrl], rec_duration: params[:RecordingDuration])
    response = Twilio::TwiML.build do |res|
      res.say "Your message has been received. Goodbye."
      res.hangup
    end
    render text: response, content_type: 'application/xml'
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
      # @account_sid = CONFIG[:twilio_account_sid]
      # @auth_token = CONFIG[:twilio_auth_token]
      # @client = Twilio::REST::Client.new @account_sid, @auth_token
      # from = "+13183034399"
      # @recipients = []
      # message.recipients.each do |r|
      #   @recipients << r.number
      # end
      # session[:user_id]
      # @recipients.each do |number|
      #   @client.account.sms.messages.create(
      #       :from => from,
      #       :to => number,
      #       :body => message.body
      #     )
      #   end
      @recipients = []
      message.recipients.each do |r|
        @recipients << r.number
      end
      session[:user_id]
      @recipients.each do |number|
        Twilio::SMS.create to: number, from: "+13183034399", body: message.body
      end
    end
    
    def send_response(to, body)
      # @account_sid = CONFIG[:twilio_account_sid]
      # @auth_token = CONFIG[:twilio_auth_token]
      # @client = Twilio::REST::Client.new @account_sid, @auth_token
      # from = "+13183034399"
      # @client.account.sms.messages.create(
      #     :from => from,
      #     :to => to,
      #     :body => body
      #   )
      Twilio::SMS.create to: to, from: "+13183034399", body: body
    end
    
    def send_notification(to, body, from_person)
      # @account_sid = CONFIG[:twilio_account_sid]
      # @auth_token = CONFIG[:twilio_auth_token]
      # @client = Twilio::REST::Client.new @account_sid, @auth_token
      from = "+13183034399"
      Twilio::SMS.create(
          :from => from,
          :to => to,
          :body => "You have a reply from #{from_person.full_name} #{from_person.mobile_number}: " + body + " conversation id: #{session[:conversation_id]}"
        )
    end
end
