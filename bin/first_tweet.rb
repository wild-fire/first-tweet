#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'
require 'lib/first_tweet'

program :version, '0.0.1'
program :description, 'Returns the first tweet of the users passed as parameter'

command :user do |c|
  c.syntax = 'First Tweet user username'
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

