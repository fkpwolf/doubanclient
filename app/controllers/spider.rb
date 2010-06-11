require 'caches.rb'
require 'open-uri'
require'oauth'
require 'oauth/consumer'

def run_before(m)  
  alias_method "__before__#{m}", m  
  define_method(m) { |*arg| puts "hahah!!!"; yield(*arg); send("__before__#{m}", *arg);}  
end

class Net::HTTP
  run_before("get")
end

class Spider 
  extend Caches
  #def self.fetch_book_reviews()
  #  fetch_reviews("book")
  #end
  
  #def self.fetch_movie_reviews()
  #  fetch_reviews("movie")
  #end
  
  #this cache didn't care parameters. Looks NOT correct
  def self.fetch_reviews(subject)
    puts "--fetch_review..."
    
    #FakeWeb.register_uri(:get, "http://www.douban.com/book/review/best/", 
    #  :body => "href=http://book.douban.com/review/3105165/...http://book.douban.com/review/3103980//..http://book.douban.com/review/3103703/http://book.douban.com/review/3105110/http://book.douban.com/review/3105208/")
    
    response = ''
		open(	feed= "http://#{subject}.douban.com/review/best/") do |http|
		  response = http.read
		end
		puts "response is:" << response
		myarray = response.scan(/review\/(\d*)\//)
		books = Array.new #can I not define type here?
		myarray.uniq.to_a.each { |id|
			books << get_review(id)
		}
		books
  end
  
  def self.get_review(id="")
					resp=get_access_token().get("/review/#{id.to_s}")
					if resp.code=="200"
									atom=resp.body
									Douban::Review.new(atom)
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
  
  class_caches :fetch_reviews, :timeout => 30.minutes
end
