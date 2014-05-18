#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'
require 'lib/first_tweet'

program :version, '0.0.1'
program :description, 'Returns the first tweet of the users passed as parameter'

default_command :user

command :user do |c|
  c.syntax = 'first_tweet.rb user username'
  c.summary = 'Returns the first tweet of the user [username]'
  c.description = 'Returns the first tweet of the user [username]'
  c.example 'Getting the first tweet from SciencePorn', 'first_tweet user SciencePorn'
  c.action do |args, options|
    username = args.first
    if username.blank?
      puts "[ERROR] We need a username"
    else
      puts FirstTweet.fetch(username).text
    end
  end
end

command :users do |c|
  c.syntax = 'first_tweet.rb users path/to/users.tsv path/to/output.tsv'
  c.summary = 'Returns the first tweets for the users'
  c.description = 'Returns the first tweets for the users'
  c.action do |args, options|

    if args.count < 2
      puts "[ERROR] We need a users file and an output"
    else
      users_file = File.open args.first
      output_file = File.open args.second, 'a'

      users_file.each_line do |l|
        user_id, username, date = l.split("\t")
        tweet = FirstTweet.fetch(username)
        if tweet
          puts "#{username}: #{tweet.text}"
          output_file << "#{tweet.id}\t#{tweet.created_at}\t#{user_id}\t#{tweet.text}\n"
          output_file.flush
          sleep 60
        end
      end
    end
  end
end
