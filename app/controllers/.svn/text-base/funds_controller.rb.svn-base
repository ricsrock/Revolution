class FundsController < ApplicationController
  
  before_filter :login_required
  
  layout 'inner'
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @fund_pages, @funds = paginate :funds, :per_page => 10
  end

  def show
    @fund = Fund.find(params[:id])
  end

  def new
    @fund = Fund.new
  end

  def create
    @fund = Fund.new(params[:fund])
    if @fund.save
      flash[:notice] = 'Fund was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @fund = Fund.find(params[:id])
  end

  def update
    @fund = Fund.find(params[:id])
    if @fund.update_attributes(params[:fund])
      flash[:notice] = 'Fund was successfully updated.'
      redirect_to :action => 'show', :id => @fund
    else
      render :action => 'edit'
    end
  end

  def destroy
    Fund.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
