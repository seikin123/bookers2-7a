class Book < ApplicationRecord
  validates :title, presence: true
  validates :body, length: { in: 1..200 }
  belongs_to :user

  # フォロー機能
  has_many :following_user, through: :follower, source: :followed # 自分がフォローしている人
  has_many :follower_user, through: :followed, source: :follower # 自分をフォローしている人

  # コメント機能
  has_many :book_comments, dependent: :destroy
  
  # いいね機能
  has_many :favorites, dependent: :destroy

  def self.last_week # メソッド名
    # to  = Time.current.at_beginning_of_day
    # from  = (Time.current.at_beginning_of_day - 6.day).at_end_of_day
    Book.joins(:favorites).where(favorites: { created_at: (Time.current.at_beginning_of_day - 6.day).at_end_of_day}).group(:id).order("count(*) desc")
  end


  # 検索機能
    def self.looks(searches, words)
      if searches == "perfect_match"
        @book = Book.where("title LIKE?","#{words}")
      elsif searches == "forward_match"
        @book = Book.where("title LIKE?","#{words}%")
      elsif searches == "backward_match"
        @book = Book.where("title LIKE?","%#{words}")
      elsif searches == "partial_match"
        @book = Book.where("title LIKE?","%#{words}%")
      else
        @book = Book.all
      end
  end
end
