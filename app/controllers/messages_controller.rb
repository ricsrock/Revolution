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
    @body = params[:Body]
    if session[:scenario] && session[:scenario] == 'updateme'
      #do something with this person!
      # body = "So, you wanna be updated? Here's what I got: #{params[:Body]}" 
      # send_response(params[:From], "Hi there! #{body}")
      body = params[:Body]
      data = body.split(' ')
      if data.length > 2
        last = data.last.strip
        first = data[0..-2].join(' ').strip
      elsif data.length == 2
        last = data.last.strip
        first = data.first.strip
      else
        last = data.first.strip
        first = data.last.strip
      end
      conditions = ['first_name LIKE ? AND last_name LIKE ?', first, last]
      person = Person.where(conditions)
      if person.length == 1
        mobile = CommType.where(name: 'Mobile').first
        phone = person.first.phones.new(number: params[:From][-10..-1], primary: true, comm_type_id: mobile.id)
        if phone.save
          body = "Your phone number has been updated. Please try to checkin again."
        else
          body = "There was a problem updating your phone number. Sorry. A human wil have to bail me out. They'll be in touch."
        end
      elsif person.length > 1
        body = "We found more that one person with the same name. Sorry."
      else
        body = "We couldn't find anyone by that name. Sorry."
      end
      send_response(params[:From], "Hi there! #{body}")
      session[:scenario] = nil
      
    # see if this text is parse-able...
    # check for checkin request
    elsif @body.downcase.strip.starts_with?('checkin')
      # hey! We've got a parse-able text! Someone wants to checkin!
      session[:conversation_id] ||= params[:From]
      person = Person.where('phones.number = ?', params[:From][-10..-1]).joins(:phones).first
      if person
        #we know who we have on the line... try to check 'em in
        m = params[:Body]
        data = m.split(' ')
        meeting = Meeting.find_by_checkin_code(data.last.strip)
        # meeting#current specifies that the meeting must have a date that is within a 2-day window of now.
        # You can't text-checkin into far-past or far-future events.
        if meeting && meeting.current?
          # checkin this person!
          attendance = person.checkin(group_id: meeting.group.id, instance_id: meeting.instance.id, checkout_time: Time.now)
          if attendance.persisted?
            body = "You've been successfully checked into #{attendance.group.name}!"
          else
            body = "Sorry. Couldn't check you in: #{attendance.errors.full_messages.to_sentence}"
          end
        elsif group = Group.where(checkin_code: data.last.strip).first
          if group
            this_week = Date.today.beginning_of_week.to_s(:db)..Date.today.end_of_week.to_s(:db)
            if meeting = Meeting.where('events.date IN (?)', this_week).where(group_id: group.id).includes(instance: :event).references(:events, :instances).first
              # checkin this person!
              attendance = person.checkin(group_id: meeting.group.id, instance_id: meeting.instance.id, checkout_time: Time.now)
              if attendance.persisted?
                body = "You've been successfully checked into #{attendance.group.name}!"
              else
                body = "Sorry. Couldn't check you in: #{attendance.errors.full_messages.to_sentence}"
              end
            else
              body = "Sorry. It looks like you want to checkin, but we couldn't find a current meeting for #{group.name}."
            end
          else
            body = "Sorry. It looks like you want to checkin, but we can't find a meeting matching your message information."
          end
        else
          body = "Sorry. It looks like you want to checkin, but we can't find a meeting matching your message information."
        end
      else
        #we don't know who we have on the line...
        body = "We couldn't find a person matching your phone number. Text back your first & last name and we'll update your number in our system."
        session[:scenario] = "updateme"
      end
      send_response(params[:From], "Hi there! #{body}") 
         
    # check for menu request...
    elsif @body.downcase.strip.starts_with?('menu')
      send_response(params[:From], "Hi there! #{Setting.menu}")
      
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
    @call.update_attributes(rec_sid: params[:RecordingSid], rec_url: params[:RecordingUrl], rec_duration: params[:RecordingDuration],
                            audio: params[:RecordingUrl] + '.mp3')
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
      params[:message][:from] = Figaro.env.twilio_from
      params.require(:message).permit!
    end
    
    def send_message(message)
      @recipients = []
      message.recipients.each do |r|
        @recipients << r.number
      end
      session[:user_id]
      @recipients.each do |number|
        Twilio::SMS.create to: number, from: Figaro.env.twilio_from, body: message.body
      end
    end
    
    def send_response(to, body)
      Twilio::SMS.create to: to, from: Figaro.env.twilio_from, body: body
    end
    
    def send_notification(to, body, from_person)
      from = Figaro.env.twilio_from
      Twilio::SMS.create(
          :from => from,
          :to => to,
          :body => "You have a reply from #{from_person.full_name} #{from_person.mobile_number}: " + body + " conversation id: #{session[:conversation_id]}"
        )
    end
end
