class ApplicationController < ActionController::Base
  # All from http://railscasts.com/episodes/250-authentication-from-scratch-revised?view=comments
  protect_from_forgery
  private

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    helper_method :current_user # allows the method to be accessed from …

    # Control what non logged in user sees, but not sure I'm using
    def authorize
      redirect_to login_url, alert: "Not authorized since not logged in" if current_user.nil?
    end
end
