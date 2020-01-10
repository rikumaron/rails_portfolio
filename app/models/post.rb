class Post < ApplicationRecord
  #リレーション
  belongs_to :user
  has_many :post_images, dependent: :destroy
  has_many :post_likes, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  
  # @posts = Post.where(user_id: @user.id)
  # #post_imageテーブルに登録するファイル名をpostインスタンスに格納
  # @post.post_images.new(name: upload_file_name)
  # #データベースに保存
  # if @post.save
  #     #成功
  #     redirect_to top_path
  #     flash[:danger] = "投稿しました。"
  # else
  #     #失敗
  #     flash[:danger] = "投稿に失敗しました。"
  #     render new_post_path# and return
  # end
  
  # #投稿が特定のユーザーにいいね！されているかどうかを判定
  # def like_from?(user)
  #   self.post_likes.exists?(user_id: user.id)
  # end
end
