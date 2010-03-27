require 'rss'
require 'open-uri'
require 'douban'
require'oauth'
require 'oauth/consumer'
require 'net/http'

require'rexml/document' #ri, ugly

require "erb"

require "spider"
include ERB::Util

class TController < ApplicationController
  def index
    if (cookies[:access_token_token] == nil) #just a simple authorized?
      continueAuth
      c = get_people
      session[:me] = c
      #then we can remember this people
      visitlog = Visitlog.new
      visitlog.uid = c.uid
      visitlog.ip = request.remote_ip
      visitlog.last_visit = Time.now
      visitlog.save
    end
	end

  #get all reviews of one book
	def reviews_of_a_book
					puts 't_controller.refresh'

=begin
	proxy_addr = 'proxy.cognizant.com'
	proxy_port = 6050
	res = Net::HTTP::Proxy(proxy_addr, proxy_port).start('api.douban.com') { |http|
					http.get('/movie/subject/1424406/reviews')
	}
	response = res.body
=end	
open(	feed= "http://api.douban.com/movie/subject/1424406/reviews") do |http|
	response = http.read    
	result = RSS::Parser.parse(response, false)
	@items = result.items
end				
render :partial => 'blog_entries'
	end


  def get_popular_reviews(subject="book")
    #if(subject == "book")
		#  @books = Spider.fetch_book_reviews().sort_by{rand}[1..6]
		#else
		#  @books = Spider.fetch_movie_reviews().sort_by{rand}[1..6]
	  #end
	  @books = Spider.fetch_reviews(subject).sort_by{rand}[1..6]
		
		#render :partial => 'review_entries'
		render :json => @books.to_json
  end
  
  #get summary review of one book, or one movie
	def get_review(id="")
					resp=get_access_token().get("/review/#{id.to_s}")
					if resp.code=="200"
									atom=resp.body
									Douban::Review.new(atom)
					else
									puts resp
									nil
					end
	end

	def get_subject(id="", type="book")
					resp=get_access_token().get("/#{type}/subject/#{id.to_s}")
					if resp.code=="200"
									atom=resp.body
									Douban::Book.new(atom)
					else
									nil
					end
	end
	
	def continueAuth
	  api_key = REGISTRY[:api_key]
		api_key_secret = REGISTRY[:api_key_secret]
		token = params['oauth_token']
		puts "3.0 rebuild request token"
		request_token = OAuth::RequestToken.new(
						OAuth::Consumer.new(
										api_key, 
										api_key_secret, 
										{ 
						:site=>"http://www.douban.com",
						:request_token_path=>"/service/auth/request_token",
						:access_token_path=>"/service/auth/access_token",
						:authorize_path=>"/service/auth/authorize",
						:signature_method=>"HMAC-SHA1",
						:scheme=>:header,
						:realm=>"http://yoursite.com"
		      }
		      ),
					token, cookies[:request_token_secret]
		)
		puts "3.1 get access Token"
		access_token=request_token.get_access_token
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
						access_token.token,
						access_token.secret
		)

		cookies[:access_token_token] = {:value => access_token.token, :expires => 30.days.from_now}
		cookies[:access_token_secret] = {:value => access_token.secret, :expires => 30.days.from_now}
	end

	def get_access_token()
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
									cookies[:access_token_token],
									cookies[:access_token_secret]
					)
	end

	#get full content of a review
	def expand()
					id = params['id'].scan(/review\/(\d*)/)[0]
					type = params['type']
					if type == "search" #expand a search result item
					  #when type is search is like http://api.douban.com/book/subject/1103015
					  idd = id.scan(/subject\/(\d*)/)[0]
					  subject_type = id.scan(/com\/(\w*)\//)[0]
					  @subject = get_subject(idd, subject_type)
					  case subject_type.to_s
					  when "book"
  					  render :partial => 'book_details'
  					  return
  					when "movie"
  					  render :partial => 'movie_details'
  					  return
					  end
					  
					else
					  response = '';
  					open(	feed= "http://www.douban.com/j/review/#{id}/fullinfo?show_works=False") do |http|
  									response = http.read
  					end
  					f = response.gsub(/review-panel.*form/,'')#just clear up response roughly
  					respond_to do |format|
  									format.json { render :json => f }
  					end
					end
					
	end

  def menu
    render :partial => 'menu'
  end
  
  #when refresh entries div, all button will go into here
  def refresh_entries
    id = params['id']
    puts "refresh_entries...." << id
    case id
    when "most-popular-book-review"
      get_popular_reviews('book')
    when "contact-miniblog"
      contact_miniblog
    when "most-polular-movie-review"
      get_popular_reviews('movie')
    when "back-to-feeds"
      menu
    end
  end
  
  def get_people(uid="@me")
    resp=get_access_token().get("/people/#{url_encode(uid.to_s)}")
    if resp.code=="200"
      atom=resp.body
      Douban::People.new(atom)
    else
      puts resp
      nil
    end
  end
  
  #get miniblog of all of my neighbour
  def contact_miniblog(user_id="@me",option={:start_index=>1,:max_results=>10})
    resp=get_access_token().get("/people/#{url_encode(user_id.to_s)}/miniblog/contacts?start-index=#{option[:start_index]}&max-results=#{option[:max_results]}")
    if resp.code=="200"
      atom=resp.body
      doc=REXML::Document.new(atom)
      @miniblogs=[]
      REXML::XPath.each(doc,"//feed/entry") do |entry|
        miniblog=Douban::Miniblog.new(entry.to_s)
        @miniblogs<<miniblog
      end
      @miniblogs
    else
      puts "----wori, find error" << resp.body
      nil
    end
    
    render :partial => 'contact_miniblog'
    
  end
  
  
  def search(tag="",option={:start_index=>1,:max_results=>10})
    tag = params[:search_criteria]
    subject_cat = params[:subject_cat] #FIXME here should narrow the value
    resp=get_access_token().
      get("/#{subject_cat}/subjects?tag=#{url_encode(tag.to_s)}&start-index=#{option[:start_index]}&max-results=#{option[:max_results]}")

    if resp.code=="200"
      atom=resp.body
      doc=REXML::Document.new(atom)
      @books=[]
      REXML::XPath.each(doc,"//entry") do |entry|
        @books << Douban::Book.new(entry.to_s)
      end
      @books
    else
      puts "----wori, find error" << resp.body
      nil
    end

    render :partial => 'search_result'
    
  end
  
  #post a mini blog
  def miniblog
    content = params[:miniblog_content]
    #here %q and %Q is quite different on display of textmate
    #does textmate do some special for rails? if so, it will be ugly
    response = get_access_token().post "/miniblog/saying", %Q{<?xml version='1.0' encoding='UTF-8'?>
<entry xmlns:ns0="http://www.w3.org/2005/Atom" xmlns:db="http://www.douban.com/xmlns/">
<content>#{content}</content>
</entry>},  {"Content-Type" =>  "application/atom+xml"}
    
  end
  
  #this just create review on a book or movie, can't on other's review
  def create_review(subject_link="",title="no title",content="",rating=5)
    content = params[:content]
    subject_link = params[:subject_link]
    entry=%Q{<?xml version='1.0' encoding='UTF-8'?>
                  <entry xmlns:ns0="http://www.w3.org/2005/Atom">
                  <db:subject xmlns:db="http://www.douban.com/xmlns/">
                  <id>#{subject_link}</id>
                  </db:subject>
                  <content>#{content}</content>
                  <gd:rating xmlns:gd="http://schemas.google.com/g/2005" value="#{rating}" ></gd:rating>
                  <title>#{title}</title>
                  </entry>
    }
    resp=get_access_token().post "/reviews",entry,{"Content-Type" => "application/atom+xml"}
    if resp.code=="201"
      true
    else
      puts resp.body
      false
    end
  end
  
  def bookmark_subject( subject_id="",content="",rating=5,status="wish",tag=[],option={ :privacy=>"public"})
    subject_id = params[:subject_id]
    db_tag=""
    if tag.size==0
      db_tag='<db:tag name="mine" />'
    else
      tag.each do |t|
        db_tag+='<db:tag name="'+t.to_s+'" />'
      end
    end
    entry=%Q{<?xml version='1.0' encoding='UTF-8'?>
      <entry xmlns:ns0="http://www.w3.org/2005/Atom" xmlns:db="http://www.douban.com/xmlns/">
      <db:status>#{status}</db:status>
      #{db_tag}
      <gd:rating xmlns:gd="http://schemas.google.com/g/2005" value="#{rating}" />
      <content>#{content}</content>
      <db:subject>
       <id>#{subject_id}</id>
       </db:subject>
       <db:attribute name="privacy">#{option[:privacy]}</db:attribute>
      </entry>
      }
    resp=get_access_token().post("/collection",entry,{"Content-Type"=>"application/atom+xml"})
    if resp.code=="201"
      true
    else
      puts "douban complain:" << resp.body
      false
    end
  end
      

end
