module Api
    class ApiController < ApplicationController

      protect_from_forgery with: :null_session
    #   before_action :doorkeeper_authorize!
    
      skip_before_action :verify_authenticity_token
    
      respond_to :json
      # helper method to access the current user from the doorkeeper token
    
    #   def current_user
      
    #     # p doorkeeper_token
    #     @current_user ||= User.find_by(id: doorkeeper_token[:resource_owner_id]) if doorkeeper_token
    #   end

    end
end