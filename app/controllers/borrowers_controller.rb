class BorrowersController < ApplicationController

  before_action :require_login, except: [:new, :create]
  # before_action :require_correct_user, only: [:show, :edit, :update, :destroy]

  def create
    borrower = Borrower.create(borrower_params)
    if borrower.save
      session[:user_id] = borrower.id
      redirect_to "/borrowers/#{borrower.id}"
    else
      flash[:borrower_errors] = borrower.errors.full_messages
      redirect_to :back
    end
  end

  def show
    @borrower = Borrower.find(session[:user_id])
    @nicepeople = Lender.joins(:transactions).where("borrower_id = #{session[:user_id]}").select("first_name, last_name, email, amount")
    @raised = Lender.joins(:transactions).where("borrower_id = #{session[:user_id]}").select("borrower_id, sum(amount) as donations")
    @totalraised = Lender.joins(:transactions).sum(:amount, :conditions => {:borrower_id => [session[:user_id]]})
  end

  private
  def borrower_params
    params.require(:borrower).permit(:first_name, :last_name, :email, :password, :password_confirmation, :purpose, :description, :money)
  end

end
