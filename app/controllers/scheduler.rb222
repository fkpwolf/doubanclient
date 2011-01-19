require 'rubygems'
require 'rufus/scheduler'

scheduler = Rufus::Scheduler.start_new
logger = RAILS_DEFAULT_LOGGER

#when server started
scheduler.every '2s' do
  puts "order ristretto"
  #puts Test.getTime()
  #Spider.fetch_reviews("book")
  #sleep(120)
  #Spider.fetch_reviews("movie")
  #sleep(120)
  #Spider.fetch_reviews("music")
  logger.flush 
end

scheduler.every '8s' do
  puts 'check blood pressure'
  Test.setTime(Time.new)
  
end
