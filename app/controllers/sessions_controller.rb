class SessionsController < ApplicationController

  def index
  end

  def login
  end

  def logging_in
    if lender = Lender.find_by(email: params[:email])
      if lender.authenticate(params[:password])
        session[:user_id] = lender.id
        redirect_to "/lenders/#{lender.id}"
      end
    elsif borrower = Borrower.find_by(email: params[:email])
      if borrower.authenticate(params[:password])
        session[:user_id] = borrower.id
        redirect_to "/borrowers/#{borrower.id}"
      end
    else
      flash[:error] = "Invalid Credentials"
      redirect_to "/login"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to "/login"
  end

end
