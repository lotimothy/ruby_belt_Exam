class LendersController < ApplicationController

  before_action :require_login, except: [:new, :create]
  # before_action :require_correct_user, only: [:show, :edit, :update, :destroy]

  def create
    lender = Lender.create(lender_params)
    if lender.save
      session[:user_id] = lender.id
      redirect_to "/lenders/#{lender.id}"
    else
      flash[:lender_errors] = lender.errors.full_messages
      redirect_to :back
    end
  end

  def show
    @lender = Lender.find(session[:user_id])
    @needypeople = Borrower.all
    @otherpeople = Borrower.joins(:transactions).where("lender_id = #{session[:user_id]}").select("first_name, last_name, purpose, description, money, raised, amount")
  end

  def lending
    Transaction.create(amount:params[:transaction][:amount], borrower_id:params[:transaction][:borrower_id], lender_id:params[:transaction][:lender_id])
    redirect_to :back
  end

  private
  def lender_params
    params.require(:lender).permit(:first_name, :last_name, :email, :password, :password_confirmation, :money)
  end

end
