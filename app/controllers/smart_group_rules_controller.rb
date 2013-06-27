class SmartGroupRulesController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_smart_group_rule, only: [:show, :edit, :update, :destroy]

  # GET /smart_group_rules
  # GET /smart_group_rules.json
  def index
    @smart_group_rules = SmartGroupRule.all
  end

  # GET /smart_group_rules/1
  # GET /smart_group_rules/1.json
  def show
  end

  # GET /smart_group_rules/new
  def new
    @smart_group_rule = SmartGroupRule.new
  end

  # GET /smart_group_rules/1/edit
  def edit
  end

  # POST /smart_group_rules
  # POST /smart_group_rules.json
  def create
    @smart_group_rule = SmartGroupRule.new(smart_group_rule_params)

    respond_to do |format|
      if @smart_group_rule.save
        format.html { redirect_to @smart_group_rule, notice: 'Smart group rule was successfully created.' }
        format.json { render action: 'show', status: :created, location: @smart_group_rule }
      else
        format.html { render action: 'new' }
        format.json { render json: @smart_group_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /smart_group_rules/1
  # PATCH/PUT /smart_group_rules/1.json
  def update
    respond_to do |format|
      if @smart_group_rule.update(smart_group_rule_params)
        format.html { redirect_to @smart_group_rule, notice: 'Smart group rule was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @smart_group_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /smart_group_rules/1
  # DELETE /smart_group_rules/1.json
  def destroy
    @smart_group = @smart_group_rule.smart_group
    if @smart_group_rule.destroy
      flash[:notice] = "Smart Group Rule was successfully destroyed."
    else
      flash[:alert] = "Smart Group Rule could not be destroyed. Errors: #{@smart_group_rule.errors.full_messages {|m|}.to_sentence}."
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_smart_group_rule
      @smart_group_rule = SmartGroupRule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def smart_group_rule_params
      params[:smart_group_rule]
    end
end
