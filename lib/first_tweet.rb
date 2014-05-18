require 'yaml'
require 'open-uri'
require 'json'
require 'twitter'
require 'nokogiri'
require 'active_support/all'

class FirstTweet

  def self.client
    @@client ||= Twitter::REST::Client.new do |config|
      yml_config = YAML.load_file( File.expand_path('../config/twitter.yml', File.dirname(__FILE__)) )['twitter'].symbolize_keys
      config.consumer_key        = yml_config[:consumer_key]
      config.consumer_secret     = yml_config[:consumer_secret]
      config.access_token        = yml_config[:access_token]
      config.access_token_secret = yml_config[:access_token_secret]
    end
    @@client
  end

  def self.fetch username

    tweet = nil

    while tweet.nil?

      response = open("https://discover.twitter.com/first-tweet?username=#{username}",
        "user-agent" => "Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.14 Safari/537.36",
        "referer" => "https://discover.twitter.com/first-tweet",
        "accept-encoding" => "gzip,flate,sdch",
        "x-requested-with" => "XMLHttpRequest")

      response = Zlib::GzipReader.new(response) if response.content_encoding.include?('gzip')
      response = response.readlines.join
      begin
        tweet = JSON.parse response

        unless tweet['status_id']
          puts "[WARN] First tweet for user #{username} not found. It may not exist"
          return nil
        end

        puts "fetching #{tweet['status_id']}"
        tweet = client.status tweet['status_id']
      rescue  JSON::ParserError => e
        tweet = nil
        puts "[WARN] Not valid JSON, trying to fetch from the HTML"
        File.open('jsonerror.log', 'w') { |file| file.write(response) }
        tweet_page = Nokogiri::HTML(response)
        tweet_id = tweet_page.css('div#first-tweet-wrapper a')
        if tweet_id.count > 0
          tweet_id = tweet_id.first['href'].match(/\/[0-9]+$/)
          if tweet_id[0]
            tweet_id = tweet_id[0].gsub(/^\//, '')
            puts puts "fetching #{tweet_id}"
            tweet = client.status tweet_id
          else
            puts "[WARN] Not HTML either. We will wait"
            sleep 60
          end
        else
          puts "[WARN] Not HTML either. We will wait"
          sleep 60
        end
      end
    end

    tweet
  end
end

