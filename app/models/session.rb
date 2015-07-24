class Session < ActiveRecord::Base
	# yo, we tried… and failed

	# before_action :update_session_time
	# before_action :session_expires
	# require 'date'
	#
	# def update_session_time
	#  session[:expires_at] = 1.minutes.from_now
	# end
	#
	# def session_expires
	#  @time_left = (session[:expires_at] - Time.now).to_i
	#  unless @time_left > 0
	# 	 reset_session
	# 	 flash[:error] = 'Sorry, you took too long.'
	# 	 redirect_to :controller => 'product', :action => 'index'
	#  end
	# end
end
