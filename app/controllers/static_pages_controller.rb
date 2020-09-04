class StaticPagesController < ApplicationController
  def home
	if logged_in?
		@home_feed_id = params[:home_feed_id]
		@tag = params[:search_tag]
		@is_searched = params[:is_searched]
		@feed_items = current_user.feed.where("lower(name) LIKE :search ", search: "%#{@tag}%")
		@feed_items = @feed_items.paginate(page: params[:page], per_page: 5)
		
		if @home_feed_id != "0"
		    if (@home_feed_id != nil &&  @home_feed_id != "0")
		    	@feed_items = current_user.feed.where(category_id: @home_feed_id ).paginate(page: params[:page], per_page: 5)
	    	end
	    end
	end
  end

  def homefeed
  	@home_feed_id = params[:home_feed_id]
  	redirect_to root_path(home_feed_id: @home_feed_id)
  end

  def search
  	if params[:search].blank?  
	    redirect_to(root_path) and return  
	else  
		@parameter = params[:search].downcase  
		@feed_items = current_user.feed
    	@feed_items = @feed_items.where("lower(name) LIKE :search", search: "%#{@parameter}%")
    	redirect_to root_path(search_tag: @parameter,is_searched: true)
	end 
  end

  def help

  end

  def about
  end

  def contact
  end

end
