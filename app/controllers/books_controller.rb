class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_current_user, {only: [:edit,:update,:destroy]}
  
  def correct_book
    @book = Book.find(params[:id])
    unless @book.user_id == current_user.id
      redirect_to books_pat
    end
  end
  
  def index
    @books = Book.all
    @book = Book.new
    @user = User.find(current_user.id)
  end 
  
  def show
    @book = Book.new
    @book = Book.find(params[:id])
    
  end 
  
  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice]= "You have created book successfully."
      redirect_to book_path(@book)
    else
      flash[:notice] = "error"
      @books = Book.all
      @user = current_user
      render :index
    end 
  end 
  
  def edit 
    @book = Book.find(params[:id])

  end 
  
  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@book.id)
    else
      render :edit
    end 
  end
  
  def destroy
    book =Book.find(params[:id])
    book.destroy
    flash[:destroy] = Book "was successfully destroyed."
    redirect_to books_path
  
  end 
  
  
  private
    
    def book_params
      params.require(:book).permit(:title, :body)
    end 
    def user_params
    params.require(:user).permit(:name,:profile_image,:introduction)
    end

    def  ensure_current_user
      @book = Book.find(params[:id])
     if @book.user_id != current_user.id
        redirect_to books_path
     end
    end
end 