class ItemsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :edit]
  before_action :seller_user, only: [ :destroy, :edit]
  skip_before_action :verify_authenticity_token, only: [ :purchase ]

  def new
  	#@categories = Category.all.collect{ |u| [ u.name, u.id.to_i ] }
  	@item = Item.new
  end

  def index
  	@items = Item.all
  end

  def edit
  	if Item.exists?(id: params[:id]) 
  		@item = Item.find(params[:id])
  		if @item.sold == true
  			flash[:danger] = "Item sold out"
			redirect_to root_url
		end
  	else
    	flash[:danger] = "Item unavailable"
		redirect_to root_url
	end
  end

  def show
  	if Item.exists?(id: params[:id]) 
		@item = Item.find(params[:id])
	end	
  end

  def create
  	ver_params = item_params
  	ver_params[:category_id]  = item_params[:category_id].to_i
  	if ver_params[:category_id] == 0
  		@category_name = item_params[:category]
  		@verp = Hash.new
  		@verp[:name] = @category_name
  		@new_cat = Category.new(@verp)
  		if @new_cat.save
  			ver_params[:category_id] = @new_cat.id
  			@item = Item.new(ver_params.except(:category))
		  	if @item.save
		  		@seller = Seller.new
		  		@seller.update_attribute(:user_id, session[:user_id])
		  		@seller.update_attribute(:item_id, @item.id)
		  		if @seller.save
			  		flash[:success] = "Item created"
			        redirect_to root_url
			    else
			    	flash[:danger] = "Item not added to sellers table"
			    end
			end
		else
			flash[:danger] = "Category already exists"
  			render 'new'
	  	end
  	else
	  	@item = Item.new(ver_params.except(:category))
  		@seller = Seller.new
  		@seller.update_attribute(:user_id, session[:user_id])
  		@seller.update_attribute(:item_id, @item.id)
  		if @seller.save
	  		flash[:success] = "Item created"
	        redirect_to root_url
	    else
	    	flash[:danger] = "Item not added to sellers table"
	    end
	  
	end
  end

  def buy
  	@user = User.find(session[:user_id])
  	@id = params[:item_id]
  	if Item.exists?(id: @id)
	  	@item = Item.find(@id)
	  	if !@item.sold
		  	@buyer = Buyer.new
			@item.update_attribute(:sold, true)
		  	@buyer.update_attribute(:user_id, session[:user_id])
  			@buyer.update_attribute(:item_id, @item.id)
  			@buyer.save
		  	render 'purchase'
		 
		else
			flash[:danger] = "Item unavailable"
			redirect_to root_url
		end
	else
		flash[:danger] = "Item unavailable"
		redirect_to root_url
	end
	
  end


  def purchase
  	@itemid = params[:item_id]
  	@item = Item.find(@itemid)
	flash[:success] = "Item named #{@item.name} has been brought"
	redirect_to root_url
  end


  def update
  	@item = Item.find(params[:id])
  	ver_params = item_params
  	ver_params[:category_id]  = item_params[:category_id].to_i
  	if ver_params[:category_id] == 0
  		@category_name = item_params[:category]
  		@verp = Hash.new
  		@verp[:name] = @category_name
  		@new_cat = Category.new(@verp)
  		@new_cat.save
  		ver_params[:category_id] = @new_cat.id
  	end
  	if @item.update(ver_params.except(:category))
  	   flash[:success] = "Item Updated"
       redirect_to current_user
    else
    	render 'edit'
    end
  end

  def destroy
  	if Item.exists?(id: params[:id])
	  	@item = Item.find(params[:id])
	  	if @item.sold == true
  			flash[:danger] = "Item sold out"
			redirect_to root_url
		else
			@item.destroy
			flash[:success] = "Item deleted"
			redirect_to request.referrer || root_url
		end
	else
    	flash[:danger] = "Item unavailable"
		redirect_back_or root_url
	end
  end

  private

    def item_params
      params.require(:item).permit(:name, :category_id, :category, :price, :description, :picture)
    end

     # Confirms a logged-in user.
    def logged_in_user
      
      unless logged_in?

        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def seller_user
    	if Item.exists?(id: params[:id])
	    	@item = Item.find(params[:id])
	    	unless current_user?(@item.seller.user)
	    		store_location
	    		flash[:danger] = "Unauthorized content"
	        	redirect_to root_url
	        end
	    else
	    	flash[:danger] = "Item unavailable"
			redirect_back_or root_url
		end
    end

end
