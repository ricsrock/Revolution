class HomeController < ApplicationController
    before_filter :login_from_cookie
    
    layout :depends
    
    def index
      
    end
    
    private
    def depends
        if cookies[:portlet] == 'portlet'
          'portlet'
        else
          'application'
        end
      end
end
