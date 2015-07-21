class Session < ActiveRecord::Base

	# deletes long sessions
	# not sure how it works

	# def self.sweep(time = 1.hour) # converts to 3600 seconds
	# 	if time.is_a?(String)
	# 		time = time.split.inject { |count, unit| count.to_i.send(unit) }
	# 	end
	#
	# 	delete_all "updated at < '#{time.ago.to_s(:db)}'"
	# end
end
