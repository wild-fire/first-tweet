require 'yaml'
require 'open-uri'
require 'json'
require 'twitter'
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
        puts "fetching #{tweet['status_id']}"
        tweet = client.status tweet['status_id']
      rescue  JSON::ParserError => e
        tweet = nil
        puts "Not valid JSON, waiting for ordering a new one"
        sleep 60
      end
    end

    tweet
  end
end

