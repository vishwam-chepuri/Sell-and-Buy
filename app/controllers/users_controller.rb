class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]

  before_action :correct_user,   only: [:edit, :update]

  before_action :admin_user,     only: :destroy

  def index
  	@users = User.paginate(page: params[:page], per_page: 10)
  end

  def show
    if User.exists?(id: params[:id])
      @user = User.find(params[:id])
      @profile_feed_id = params[:profile_feed_id]
      sale_items = @user.sale_items.pluck(:item_id)
      @items = Item.where(id: sale_items).where(sold: false).paginate(page: params[:page], per_page: 5)
      @heading = "Items for Sale"
      if current_user?(@user)
        if( @profile_feed_id == "1")
          sale_items = @user.sale_items.pluck(:item_id)
          @heading = "Items for Sale"
          @items = Item.where(id: sale_items).where(sold: false).paginate(page: params[:page], per_page: 5)
         
        elsif( @profile_feed_id == "2")
          sale_items = @user.sale_items.pluck(:item_id)
          @heading = "Items Sold"
          @items = Item.where(id: sale_items).where(sold: true).paginate(page: params[:page], per_page: 5)
         
        elsif( @profile_feed_id == "3")
          brought_items = @user.brought_items.pluck(:item_id)
          @heading = "Items bought"
          @items = Item.where(id: brought_items).paginate(page: params[:page], per_page: 5)
          
        end
      end
    else
      flash[:danger] = "User unavailable"
      redirect_back_or root_url
    end
  end

  def profilefeed
    @profile_feed_id = params[:profile_feed_id]
    @user_id = current_user.id
    # byebug
    redirect_to user_path(profile_feed_id: @profile_feed_id, id: @user_id)
  end

  def new
    @user = User.new
    if logged_in?
      redirect_to root_url
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to root_url
    else
      render 'new'
    end
  end

  def sendotp
    @user = User.find_by(id: session[:user_id])
    @user.generate_pin
    @user.send_pin
    redirect_to users_OTPverifypage_path
  end

  def OTPverifypage
    @user = User.find_by(id: session[:user_id])
    render 'verify'
  end

  def verify
    @user = User.find_by(id: params[:user_id])
    # @user.verify(params[:pin])#,gen_pin)
    @gen_pin = @user.pin
    @entered_pin = params[:pin]
    if @gen_pin == @entered_pin
      @user.update_attribute(:verified, true)
      @user.save
      log_in @user
      flash[:success] = "Mobile number Verified!"
      redirect_to root_url
    else
      # @message = "OTP incorrect"
      flash[:danger] = "OTP incorrect"
      redirect_to users_OTPverifypage_path
      
    end
   
  end


  def edit
    @user = User.find(params[:id])
  end

  def update
    if User.exists?(id: params[:id])
      @user = User.find(params[:id])
      @PH = @user.phone
      if @user.update(user_params)
        msg = "Profile updated"
        if( @PH != @user.phone)
          @user.update_attribute(:verified, false)
          msg = "Mobile number updating pending..!!"
        end
        flash[:success] = msg
        redirect_to @user
      else
        render 'edit'
      end
    else
      flash[:danger] = "User unavailable"
      redirect_back_or root_url
    end
  end

  def destroy
    if User.exists?(id: params[:id])
    	User.find(params[:id]).destroy
    	flash[:success] = "User deleted"
    	redirect_to users_url
    else
      flash[:danger] = "User unavailable"
      redirect_to users_url
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email,:phone,
                                   :address,  :password, :password_confirmation, :picture)
    end

    def pin_params
      params.require(:user).permit(:pin)
    end

    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
    	redirect_to(root_url) unless current_user.admin?
    end
end