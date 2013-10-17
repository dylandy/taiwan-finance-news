# encoding:utf-8

require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'pp'
require 'date'
require 'active_record'
require 'yaml'

class Catalog < ActiveRecord::Base ; end
class NewsTable < ActiveRecord::Base ; end

module News
  def self.initialize
    envrionment = ENV['RACK_ENV'] || 'development'
    dbconfig = YAML.load(File.read('database.yml')) #change the path of your own database.yml
   	ActiveRecord::Base.logger = Logger.new(STDOUT)
	  #ActiveRecord::Base.connection_pool.clear_reloadable_connections!
    ActiveRecord::Base.establish_dbconfig[environment]

  #go is main function 
  def self.go!
    initialize()
    news_filter()
  end
  
  def self.news_filter()
    doc = Nokogiri::HTML(open("http://www.appledaily.com.tw/appledaily/article/finance").read)
    target = doc.css( 'li.echn h1 a')  #target1 for getting all the news address
    news_addr = {}
    
	  puts "get #{target.length} news!!! yooooo!!!"

    target.each do |item|
       url = item.attr('href')
			 u_ary = url.split('/')
			 date_txt , serial = u_ary[4..5]
       serial = serial.to_i
       if !news_addr[serial]
			   news_addr[serial] ={
				   :url => "http://www.appledaily.com.tw#{u_ary[0..-2].join('/')}",
           :date => Date.parse(date_txt)
				 }
			 end
    end  # insert the address into news_addr array
		puts "db changes"
    
    NewsTable.where("serial IN (#{news_addr.keys.join(',')})").select('id , serial').each do |nt|
			news_addr.delete(nt.serial.to_i)
		end

    count = news_addr.length
		puts "so , #{count} can be save"

    i = 0
    news_addr.each_pair do |key , value|
		  i += 1

		  body = Nokogiri::HTML(open(value[:url]).read)
      img_url = body.css('figure img')[0].attr('src')
			title = body.css('title')[0].inner_html.split(' | ')[0]

			puts "now #{i} / #{count} : #{title} > #{value[:url]}"
			
			nt = NewsTable.new
			nt.log_date = value[:date]
			nt.serial = key
			nt.picture_address = img_url
			nt.news_title = title
			nt.news_address = value[:url]
			nt.save
		end

		puts "okay!!"
  end
  #while there might be to have "/" inside the title of the news , if so, drop the execution
	def self.raise_and_rescue
		begin
			go!()
		rescue
			puts 'skip'
		end
	end
end
News.raise_and_rescue
