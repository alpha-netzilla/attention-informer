
class TwilioController < ApplicationController
	def auth
		account_sid = "AC9b5206ef97ee31a0b2fa12b7b8d89304"
		auth_token = "0644e67d7da9cfc12a8f4ce62853b920"

		from = "+81********"
		#to = "+81********"
		to = params["to"]

		server = "*.*.*.*"
		#select = "http://#{@server}/twilio/direction.rb?page=select"
		#callback = "http://#{@server}/twilio/direction.rb?page=callback"
		url = "http://#{server}/twilio/answer"
	

		begin
			client = Twilio::REST::Client.new account_sid, auth_token
			client.account.calls.create(
				from: from,
				to:   to,
				url: url, 
				method: 'GET',
				timeout: 15,
				record: false
			)
			render :text => "now calling" and return
		rescue
			render :text =>	"error: #{$!.message}"
		end

  end

	def answer
		#message = params[:message]
		message = "the threshold of negative words is over"

                response = Twilio::TwiML::Response.new do |r|
                r.Say message, :voice => 'woman'
        end

		render :xml => response.text
	end
end
