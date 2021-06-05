class User < ApplicationRecord
  validates :name, presence: true, uniqueness:true, length: {in: 2..20}
  validates :introduction,length: { maximum: 50}


  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
  attachment :profile_image
  has_many :books, dependent: :destroy

  # コメント機能
  has_many :book_comments, dependent: :destroy

  # フォロー機能
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy # フォロー取得
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy # フォロワー取得
  has_many :following_user, through: :follower, source: :followed # 自分がフォローしている人
  has_many :follower_user, through: :followed, source: :follower # 自分をフォローしている人
    # ユーザーをフォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # フォローしていればtrueを返す
  def following?(user)
    following_user.include?(user)
  end

  # いいね機能
  has_many :favorites, dependent: :destroy

  def already_favorited?(book)
    self.favorites.exists?(book_id: book.id)
  end

  # 検索機能
  def self.looks(searches, word)
    if searches == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif searches == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif searches == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif searches == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end

  # 住所機能
  include JpPrefecture
  jp_prefecture :prefecture_code #都道府県コードから都道府県名に自動で変換する。

  def prefecture_name #←で都道府県名を参照出来る様にする。
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

end
