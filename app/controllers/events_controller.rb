class EventsController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_event, only: [:show, :edit, :update, :destroy, :mark, :post, :show_attendances_for]

  # GET /events
  # GET /events.json
  def index
    params[:q] = Event.fix_params(params[:q]) if params[:q]
    @q = Event.includes(:event_type, :meetings, :instances => :meetings).page(params[:page]).search(params[:q])
    @q.sorts = 'date desc' if @q.sorts.empty?
    @events = @q.result(distinct: true)
    @range = params[:q][:range_selector_cont] if params[:q]
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end
  
  def search
    @events = Event.where(:date => do_range(params[:range_selector]).start_date..do_range(params[:range_selector]).end_date).order('events.date DESC')
  end
  
  def mark
    @search = Person.includes(:household, {enrollments: :group}).order('last_name, first_name ASC').search(params[:q])
    @people = @search.result(distinct: true)
    @people = @people.where(attendance_status: 'Active') unless params[:q]
    @instances = @event.instances.includes(:instance_type).order('instance_types.name ASC')
  end
  
  def post
    @instances = @event.instances
    @instances.each do |instance|
      if params[instance.type_id.to_sym]
        params[instance.type_id.to_sym].each do |id|
          @person = Person.find(id)
          @attendance_record = @person.checkin(instance_id: instance.id, checkout_time: Time.now)
          # logger.info "=========== Attendance Record: #{@attendance_record.inspect} ============="
        end
      end
    end
    # @first_service = @event.instances.where('instance_types.name LIKE ?', '1st Service%').includes(:instance_type).references(:instance_type).first
    # if params[:instance_type_1]
    #   params[:instance_type_1].each do |id|
    #     @person = Person.find(id)
    #     @person.checkin(instance_id: @first_service.id)
    #   end
    # end
    # @second_service = @event.instances.where('instance_types.name LIKE ?', '2nd Service%').includes(:instance_type).references(:instance_type).first
    # if params[:instance_type_2]
    #   params[:instance_type_2].each do |id|
    #     @person = Person.find(id)
    #     @person.checkin(instance_id: @second_service.id)
    #   end
    # end
    redirect_to mark_event_path(@event)
  end
  
  def show_attendances_for
    @att_search = @event.attendances.includes(:person, meeting: :group).search(params[:q])
    @attendances = @att_search.result
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :event_type_id, :date)
    end
end
