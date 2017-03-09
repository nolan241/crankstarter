class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  #if a user other than the project owner tries to perform any actions, redirect to the root_url
  #ability model and custom explanation
  rescue_from CanCan::AccessDenied do |exeption|
    redirect_to root_url, :alert => exception.message
  end
  
end
