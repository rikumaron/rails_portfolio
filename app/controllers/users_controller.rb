class UsersController < ApplicationController
  before_action :authorize, except: [:sign_up, :sign_up_process, :sign_in, :sign_in_process]
  before_action :redirect_to_top_if_signed_in, only: [:sign_up, :sign_in]
  
  # ユーザー登録ページ
  def sign_up
    @user = User.new
    render layout: "application_not_login"
  end
  
  # ユーザー登録処理
  def sign_up_process
    #フォームのデータを受け取る
    user = User.new(user_params)
    
    if user.save
      #登録が成功したらサインインしてトップページへ
      user_sign_in(user)
      redirect_to top_path and return
    else
      flash[:danger] = "ユーザー登録に失敗しました。"
      # redirect_to('/sign_up')
      redirect_to sign_in_path and return
    end
  end
  
  # private
  # def user_params
  #   params.require(:user).permit(:name, :email, :password)
  # end
  
  
  #サインインページ
  def sign_in
    @user = User.new
    render layout: "application_not_login"
  end
  
  #サインイン処理
  def sign_in_process
    #パスパードをmp5に変換
    password_md5 = User.generate_password(user_params[:password])
    #メールアドレスとパスワードをもとにデータベースからデータを取得
    user = User.find_by(email: user_params[:email], password: password_md5)
    if user
      #セッション処理
      user_sign_in(user)
      #トップ画面へ遷移する
      redirect_to top_path and return
    else
      flash[:danger] = "サインインに失敗しました。"
      # redirect_to('/sign_in')
      redirect_to sign_up_path and return
    end
  end
  
  #サインアウト処理
  def sign_out
    #ユーザーセッションを破棄
    user_sign_out
    #サインインページへ遷移
    redirect_to sign_in_path and return
  end
  
  #プロフィールページ
  def show
    #ここに処理を実装
    @user = User.find(params[:id])
    @posts = Post.where(user_id: @user.id)
  end
  
  # プロフィール編集ページ
  def edit
    @user = User.find(current_user.id)
  end
   
  # プロフィール更新処理
  def update
    # ここに処理を実装
    upload_file = params[:user][:image]
    if upload_file.present?
    # あった場合はこの中の処理が実行される
      upload_file_name = upload_file.original_filename
      output_dir = Rails.root.join('public', 'images')
      output_path = output_dir + upload_file_name
      
      File.open(output_path, 'w+b') do |f|
        f.write(upload_file.read)
      end
    end
  end
  def user_params
    params.require(:user). permit(:name, :email, :password, :comment)
  end
  
  #トップページ
  def top
    if params[:word].present?
      #キーワード検索処理
      @posts = Post.where("caption like ?", "%#{params[:word]}%").order("id desc")
    else
      #一覧表示処理
      @posts = Post.all.order("id desc")
    end
    #ここに処理を実装
    @recommends = User.where.not(id: current_user.id).where.not(id: current_user.follows.pluck(:follow_user_id)).limit(3)
  end
  
  #フォロー機能
  def follow
    #ここに処理を実装
    @user = User.find(params[:id])
    if Follow.exists?(user_id: current_user.id, follow_user_id: @user.id)
      #フォローを解除
      Follow.find_by(user_id: current_user.id, follow_user_id: @user.id).destroy
    else
      #フォローする
      Follow.create(user_id: current_user.id, follow_user_id: @user.id)
      redirect_back(fallback_location: top_path, notice: "フォローを更新しました。")
    end
  end
  
  #フォローリスト
  def follow_list
    #プロフィール情報の取得
    @user = User.find(params[:id])
    #ここに処理を実装
    @users = User.where(id: Follow.where(user_id: @user.id).pluck(:follow_user_id))
  end
  
  #フォロワーリスト
  def follower_list
    
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
  
end

