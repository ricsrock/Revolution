class DonationsController < ApplicationController
  before_filter :authenticate_user!
  authorize_resource
  def index
    params[:q] = Donation.fix_params(params[:q]) if params[:q]
    @search = Donation.page(params[:page]).search(params[:q])
    @donations = @search.result
    @range = params[:q][:range_selector_cont] if params[:q]
  end

  def show
  end
  
  
  # def search_params
  #   params.require(:search).permit!
  # end
end
