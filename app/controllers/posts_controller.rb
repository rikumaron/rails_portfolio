class PostsController < ApplicationController
  #アクション処理に入る前に認証
  before_action :authorize
  def new
    @post = Post.new
    
    # @user = User.find(params[:id])
  end
  def create
    #パラメータ受け取り
    @post = Post.new(post_params)
    upload_file = params[:post][:upload_file]
    
    
    upload_file_name = upload_file.original_filename
      output_dir = Rails.root.join('public', 'images')
      output_path = output_dir + upload_file_name
      
      File.open(output_path, 'w+b') do |f|
        f.write(upload_file.read)
        
        
    #投稿画像がない場合
    if upload_file.blank?
      flash[:danger] = "投稿には画像が必須です。"
      redirect_to new_post_path and return
    end
    
    # upload_file_name = upload_file.original_filename
  end
  
  def destroy
    #ここに処理を実装
    #投稿を取得
    @post = Post.find(params[:id])
    @post.destroy
  end
  
   @posts = Post.where(user_id: @user.id)
  #post_imageテーブルに登録するファイル名をpostインスタンスに格納
  @post.post_images.new(name: upload_file_name)
  #データベースに保存
  if @post.save
      #成功
      redirect_to top_path
      flash[:danger] = "投稿しました。"
  else
      #失敗
      flash[:danger] = "投稿に失敗しました。"
      render new_post_path# and return
  end
  
  #投稿が特定のユーザーにいいね！されているかどうかを判定
  def like_from?(user)
    self.post_likes.exists?(user_id: user.id)
  end
  #いいね処理
  def like
    #ここに処理を実装
    @post = Post.find(params[:id])
    if PostLike.exists?(post_id: @post.id, user_id: current_user.id)
      #いいねを削除
      PostLike.find_by(post_id: @post.id, user_id: current_user.id).destroy
    else
      #いいねを登録
      PostLile.create(post_id: @post.id, user_id: current_user.id)
      redirect_to top_path and return
    end
  end
  
  #コメント処理実行
  def comment
    #ここに処理を実装
    #投稿IDを受け取り、投稿データを取得
    @post = Ppst.find(params[:id])
    #コメント保存
    @post.post_comment.create(post_comment_params)
    redirect_to top_path and return
  end
  #コメント用パラメータを取得
  def post_comment_params
    params.require(:post_comment).permit(:comment).merge(user_id: current_user.id)
  end
  
  private
    def post_params
      params.require(:post).permit(:caption).merge(user_id: current_user.id)
    end
  end
end
