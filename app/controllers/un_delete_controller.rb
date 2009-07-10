class UnDeleteController < ApplicationController
    
    before_filter :login_required
    require_role "supervisor"

    layout 'inner'
    
    def index
        
    end
    
    def households
        @deleted_households = Household.find_deleted
    end
    
    def un_delete_household
        id = params[:id]
        @household = Household.find_deleted_id(id)
        @household.each do |h|
            h.update_attribute(:deleted_at, nil)
        end
        flash[:notice] = "Household was successfully un-deleted."
        redirect_to :action => 'households'
    end
    
end
