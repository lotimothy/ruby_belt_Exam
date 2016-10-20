class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def require_login
    redirect_to "/" if session[:user_id] == nil
  end

  def current_user
    if session[:user_id]
      if Lender.find(session[:user_id])
      else
        Borrower.find(session[:user_id])
      end
    end
  end

  helper_method :current_user

  def require_correct_user
    if user = Lender.find(params[:id])
    else
      user = Borrower.find(params[:id])
    end
    redirect_to "/" if current_user != user
  end

end
