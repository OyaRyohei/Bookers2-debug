class BooksController < ApplicationController
  # ログインしていないと、閲覧できない
  before_action :authenticate_user!

  # ログインユーザー以外は編集・削除できない
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  # 同じ人が複数回アクセスしても1PVとカウントする
  impressionist :actions=> [:show]

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
    @user = @book.user
    impressionist(@user, nil, :unique => [:session_hash])

    @book_views = @user.impressionist_count
  end

  def index
    # 今日の23時59分59秒から
    to  = Time.current.at_end_of_day
    # １週間前まで
    from  = (to - 6.day).at_beginning_of_day
    @books = Book.all.sort {|a,b|
      b.favorites.where(created_at: from...to).size <=>
      a.favorites.where(created_at: from...to).size
    }
     @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user == current_user
      render "edit"
    else
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end
end
