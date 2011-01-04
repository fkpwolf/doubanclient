#require 'caches.rb'
require 'open-uri'
require'oauth'
require 'oauth/consumer'



class Spider 
#  extend Caches
  
  #this cache didn't care parameters. Looks NOT correct
  def self.fetch_reviews(subject)
    Rails.logger.info "------ fetch_reviews----"
    response = ''
		open(	feed= "http://#{subject}.douban.com/review/best/") do |http|
		  response = http.read
		end
		myarray = response.scan(/review\/(\d*)\//)
	
		myarray.uniq.to_a.each { |id|
		  sleep(5)
			cache = Cache.new
			cache.subject = subject
			cache.content_type = 'review'
			cache.content=get_review(id)
			cache.save
		}
  end
  
  def self.fetch_top10(subject, fix)
    Rails.logger.info "------ fetch_top10----"
    response = ''
    feed = "http://#{subject}.douban.com/chart"
    if( fix == '123' ) #non-virtual book ranking list
      feed = "http://#{subject}.douban.com/chart?subcat=F"
    elsif( fix == '134') #the latest book
      feed = "http://book.douban.com/latest";
    end
		open( feed	) do |http|
		  response = http.read
		end
		##################################################
		if(subject == 'book')
		  aclass = 'fleft'
		elsif(subject == 'movie')
		  aclass = 'nbg'
	  end
	  ##################################################
	  if ( fix == '134')
	    reg = /a href="http:\/\/#{subject}.douban.com\/subject\/(\d*)\/"/
	  elsif ( fix == '90')
  	    reg = /a onclick="moreurl\(this, \{from:'week'\}\)" href="http:\/\/#{subject}.douban.com\/subject\/(\d*)\/"/
	  elsif ( subject != 'music')
	    reg = /a class="#{aclass}" href="http:\/\/#{subject}.douban.com\/subject\/(\d*)\/"/
    else
      reg = /a href="http:\/\/#{subject}.douban.com\/subject\/(\d*)\/"/
    end
    puts reg
    myarray = response.scan(reg)
		#books = Array.new #can I not define type here?
		myarray.to_a.each { |id|
		  sleep(3)
			#books << get_subject(id, subject)
			cache = Cache.new
			cache.subject = subject
			cache.fix = fix
			cache.content_type = 'subject'
			cache.content=get_subject(id, subject)
			cache.save
		}
  end
  
  def self.get_review(id="")
					resp=get_access_token().get("/review/#{id.to_s}?alt=json")
					if resp.code=="200"
									atom=resp.body
					else
									puts resp
									nil
					end
	end
	
	def self.get_subject(id="", type="book")
					resp=get_access_token().get("/#{type}/subject/#{id.to_s}?alt=json")
					if resp.code=="200"
									atom=resp.body
					else
					    puts resp
							nil
					end
	end
	
	def self.get_access_token()
					api_key = REGISTRY[:api_key]
					api_key_secret = REGISTRY[:api_key_secret]
					access_token = OAuth::AccessToken.new(
									OAuth::Consumer.new(
													api_key,  
													api_key_secret, 
													{
									:site=>"http://api.douban.com",
									:scheme=>:header,
									:signature_method=>"HMAC-SHA1",
									:realm=>"http://yoursite.com"
					}
					),
									nil, nil
					)
	end
  
  #class_caches :fetch_reviews, :timeout => 1440.minutes #one day 24 hours
  #class_caches :fetch_top10, :timeout => 1440.minutes
end
