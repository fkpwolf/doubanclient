namespace :utils do
  desc "This task will purchase your Vodka"
  task :tt do
    puts "wori"
  end
  
  desc "clear cache"
  task :clear do
    puts "wori"
    Spider.fetch_reviews("book")
  end
end
