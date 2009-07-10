class FeedsController < ApplicationController
  
#require_role :feeds
  
    def index
      @contact_types = ContactType.find(:all, :order => :name)
    end
    
#  def feed
#      @follow_ups = FollowUp.find(:all, :include => [:contact], :order => ['follow_ups.created_at DESC'])
#      response.headers['Content-Type'] = 'application/rss+xml'
#      @feed_url = "http://" + request.host_with_port + request.request_uri
#      render :action => 'feed', :layout => false
#    end
      
      def contact_type_feed
          @message = ""
          @token = params[:token]
          @ok = true
          user = User.find_by_crypted_password(@token)
          @ok = false if user.nil? # if we have no user, we can't send the feed
          @ok = false if ! user.has_role?("feeds") unless user.nil? # if the user isn't authorized for feeds, we can't send the feed
          if @ok   
              @contact_type = ContactType.find(params[:id])
              @follow_ups = FollowUp.find(:all, :include => [:contact],
                                                :conditions => ['contacts.contact_type_id = ?',@contact_type.id],
                                                :order => ['follow_ups.created_at DESC'])
            response.headers['Content-Type'] = 'application/rss+xml'
            @feed_url = "http://" + request.host_with_port + request.request_uri
            render :action => 'contact_type_feed', :layout => false
        else
            redirect_to :action => 'something_else'
        end
    end
    
    def something_else
      render :layout => false
    end
end
