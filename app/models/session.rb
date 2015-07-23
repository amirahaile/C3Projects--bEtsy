class Session < ActiveRecord::Base

	def self.sweep
    if session[:order_id] != nil

      delete_all "created_at < '#{1.day.ago.to_s(:db)}'"
    # else
      # session[:order_id] = nil
    end
  end

	# deletes long sessions
	# not sure how it works
	# from the docs:

	# def self.sweep(time = 1.hour) # converts to 3600 seconds
	# 	if time.is_a?(String)
	# 		time = time.split.inject { |count, unit| count.to_i.send(unit) }
	# 	end
	#
	# 	delete_all "updated at < '#{time.ago.to_s(:db)}'"
	# end
end
