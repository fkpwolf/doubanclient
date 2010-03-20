require 'rubygems'
require'oauth'
require 'oauth/consumer'

class DController < ApplicationController
  def index
    if (cookies[:access_token_token] != nil) 
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
  		if access_token.get("/access_token/#{cookies[:access_token_token]}").code=="200"
        redirect_to :controller =>'t', :action => 'index'
        return
      end
    end
    api_key = REGISTRY[:api_key]
		api_key_secret = REGISTRY[:api_key_secret]
		consumer=OAuth::Consumer.new(
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
		)

		puts "1.get Request Token"
		request_token=consumer.get_request_token
		
		cookies[:request_token_secret] = request_token.secret.to_s
		puts "2. redirect"
		authorzie_url=request_token.authorize_url<<"&oauth_callback="<<REGISTRY[:url_callback]
		redirect_to authorzie_url
	end

end
