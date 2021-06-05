class SearchsController < ApplicationController
  def seach
    @range = params[:range]

    if @range == "User"
      @users = User.looks(params[:search], params[:word]) #ユーザーから探す処理(user.rbのlooksメソッドを使用)
    else
      @books = Book.looks(params[:search], params[:word]) #投稿から探す処理(book.rbのlooksメソッドを使用)
  end
end
end
