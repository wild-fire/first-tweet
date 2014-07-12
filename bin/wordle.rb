#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'
require 'open-uri'

program :version, '0.0.1'
program :description, 'Creates a wordle like image from the texts on the tweets'

default_command :create

command :create do |c|
  c.syntax = 'wordle.rb create path/to/file path/to/cloud'
  c.summary = 'Reads texts from the file and creates a wordle like image with a cloud of tags'
  c.description = 'Reads texts from the file and creates a wordle like image with a cloud of tags counting the number of appearances of each word'
  c.action do |args, options|
    texts_file = File.open args.first
    cloud_file = File.open args[1]+ '/index.html', 'w'
    words = {}
    texts_file.each_line do |line|
      line.match(/\w+/).to_a.each do |word|
        word.downcase!
        previous = words[word] || 0
        words[word] = previous + 1
      end
    end

    cloud_file << <<-html
<!DOCTYPE html>
  <html>
<head>
  <title>jQCloud Example</title>
  <link rel="stylesheet" type="text/css" href="jqcloud.css" />
  <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"></script>
  <script type="text/javascript" src="jqcloud.min.js"></script>
  <script type="text/javascript">
    /*!
     * Create an array of word objects, each representing a word in the cloud
     */
    var word_array = [
html
    words.each do |word, count|
      cloud_file << "       {text: '#{word.gsub("'", "\\'")}', weight: #{count}},\n"
    end

    cloud_file << <<-html
    ];

      $(function() {
        // When DOM is ready, select the container element and call the jQCloud method, passing the array of words as the first argument.
        $("#example").jQCloud(word_array);
      });
    </script>
  </head>
  <body>
    <!-- You should explicitly specify the dimensions of the container element -->
    <div id="example" style="width: 550px; height: 350px;"></div>
  </body>
</html>
html

    cloud_file.close

    open(args[1] + '/jqcloud.min.js', 'wb') do |file|
      file << open('https://raw.github.com/lucaong/jQCloud/master/jqcloud/jqcloud-1.0.4.js').read
    end

    open(args[1] + '/jqcloud.css', 'wb') do |file|
      file << open('https://raw.github.com/lucaong/jQCloud/master/jqcloud/jqcloud.css').read
    end

  end
end

