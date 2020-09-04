class ApplicationController < ActionController::Base
	before_action :set_no_cache
	include SessionsHelper
	require 'will_paginate/array'
  protect_from_forgery with: :exception


  
  private

    def set_no_cache
	    response.headers['Cache-Control'] = 'no-cache, no-store,
	                                        max-age=0, must-revalidate'
	    response.headers['Pragma'] = 'no-cache'
	end

	# Confirms a logged-in user.
	def logged_in_user
		unless logged_in?
			store_location
			flash[:danger] = "Please log in."
			redirect_to login_url
		end
	end
end


