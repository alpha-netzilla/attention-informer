class TwitterController < ApplicationController
  layout 'twitter'

	def search
	end


	def http_nlc(tweets)
		qsts = []
		tweets.each do |tweet|
			tweet["check"] = 1
			qsts.push(tweet)
		end

		max_thread = 10
		threads = []
		lock = Mutex::new

		max_thread.times do |i|
			threads << Thread.start do
				loop do
					break if qsts.empty?
						post_nlc(lock.synchronize { qsts.pop })
				end
			end
		end

    threads.each { |th| th.join }
	end


	def post_nlc(tweet)
		lock = Mutex::new
		account = "your account"
		password = "your password"


		id_area = "classifier_id for point (2)"
		id_contact = "classifier_id for point (3)"
		classifier_ids = [id_area, id_contact]

		for classifier_id in classifier_ids do

			uri = URI.parse("https://gateway.watsonplatform.net/natural-language-classifier-experimental/api/v1/classifiers/#{classifier_id}/classify")

			response = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
				http.open_timeout = 5
				http.read_timeout = 10
				req = Net::HTTP::Post.new(uri.path)
				req["Content-Type"] = "application/json"
    
				req.basic_auth(account, password)

				payload = {"text" => tweet["message"]["body"] }.to_json
				req.body = payload
				http.request(req)
			end

			case response
			when Net::HTTPSuccess
				json = response.body
				category   = JSON.parse(json)["classes"][0]["class_name"]
				confidence = JSON.parse(json)["classes"][0]["confidence"]

				#logger.debug category

				case classifier_id
				when id_area
					if category != "cellphone" || confidence.to_f < 0.9 
						tweet["check"] = 0
					end
				when id_contact
					if category == "telephone"
						lock.synchronize { @contacts["telephone"] += 1 }
					else
						lock.synchronize { @contacts["other"] += 1 }
					end
				end


			else
				@error = [url.to_s, response.value].join(" : ")
			end
		end
	end


	def get_twitter(uri, target)
		account = "77891c094827115b5a5ef3cd4b6617fe"
		password = "AqQVA5aMq8"

		uri = URI.parse(uri)
		response = Net::HTTP.start(uri.host) do |http|
			http.open_timeout = 5
			http.read_timeout = 10
			req = Net::HTTP::Get.new(uri.request_uri)
			req.basic_auth(account, password)
			http.request(req)
		end

		case response
		when Net::HTTPSuccess
			json = response.body
			if target == "count"
				return JSON.parse(json)["search"]["results"]
			else
				return JSON.parse(json)["tweets"]
			end
		else
			@error = [url.to_s, response.value].join(" : ")
		end
	end


	def result
		#threshold = params[:threshold][0]
		#query = params[:twitter][:query]
		interval = params[:interval][0].to_i
		#interval = 3
	
		query = "\"#{params[:image]}\""

		sentiment_negative = "sentiment:negative"
		sentiment_positive = "sentiment:positive"

		starttime = (Time.now.utc  - 3600 * interval).round.iso8601(0)
		endtime = (Time.now.utc).round.iso8601(0)

		time = "posted:#{starttime},#{endtime}"

		size = 100
		query_negative = "#{time} AND #{query} #{sentiment_negative}"
		query_positive = "#{time} AND #{query} #{sentiment_positive}"
		query_all = "#{time} AND #{query}"


		url_count  = "https://cdeservice.mybluemix.net:443/api/v1/messages/count"
		url_count_negative = url_count + "?q=(#{ERB::Util.url_encode(query_negative)})"
		url_count_positive = url_count + "?q=(#{ERB::Util.url_encode(query_positive)})"
		#url_count_all      = url_count + "?q=(#{ERB::Util.url_encode(query_all)})"

		url_search = "https://cdeservice.mybluemix.net:443/api/v1/messages/search"
		url_search_negative = url_search + "?q=(#{ERB::Util.url_encode(query_negative)})&size=#{size}"
		url_search_positive = url_search + "?q=(#{ERB::Util.url_encode(query_positive)})&size=#{size}"
		#url_search_all      = url_search + "?q=(#{ERB::Util.url_encode(query_all)})&size=#{size}"

		@count_negative = get_twitter(url_count_negative, "count")
		@count_positive = get_twitter(url_count_positive, "count")
		#@count_all = get_twitter(url_count_all, "count")

		@tweets_negative = get_twitter(url_search_negative, "search")
		@tweets_positive = get_twitter(url_search_positive, "search")
		#@tweets_all = get_twitter(url_search_all, "search")

		@contacts = {"telephone" => 0, "other" => 0}

		tn = Thread.new(@tweets_negative) do |tweets|
			http_nlc(tweets)
		end
		tp = Thread.new(@tweets_positive) do |tweets|
			http_nlc(tweets)
		end

    tn.join
    tp.join


		#logger.debug @count_positive
		#logger.debug @count_negative
		@tweets_negative.each do |tweet|
			@count_negative += -1 if tweet["check"].to_i == 0
		end

		@tweets_positive.each do |tweet|
			@count_positive += -1 if tweet["check"].to_i == 0
		end


		select_contact()

		@count_ratio = (@count_negative.to_f / (@count_positive + @count_negative)  *100.0).ceil

		logger.debug @count_positive
		logger.debug @count_negative
		logger.debug @count_ratio

	end


	def select_contact()
		if @contacts["telephone"] > @contacts["other"]
			@contact = "+81**********"
		else @contacts["telephone"] < @contacts["other"]
			@contact = "+81**********"
		end
	end

end


