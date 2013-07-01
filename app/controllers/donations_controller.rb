class DonationsController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource
  def index
    params[:q] = Donation.fix_params(params[:q]) if params[:q]
    @search = Donation.page(params[:page]).includes(:fund, :contribution => [:contributable]).search(params[:q])
    @donations = @search.result
    @range = params[:q][:range_selector_cont] if params[:q]
    @total_set = Donation.search(params[:q]).result
  end

  def show
  end
  
  
  # def search_params
  #   params.require(:search).permit!
  # end
end
