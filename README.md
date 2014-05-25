First Tweet Scrapper
====================

This set of script uses [https://discover.twitter.com/first-tweet](https://discover.twitter.com/first-tweet) website to recover the first tweet of a user and show information about it.

Since this is a robot we follow [https://discover.twitter.com/robots.txt](https://discover.twitter.com/robots.txt) instructions about what URLs we may fetch and at what rate (in fact we are more respectful than requested in robots.txt).

At the time of writing this REadme, content for this robots.txt is

```
User-agent: *

# Directories
Disallow: /includes/
Disallow: /misc/
Disallow: /modules/
Disallow: /profiles/
Disallow: /scripts/
Disallow: /themes/

# Files
Disallow: /cron.php

# Paths (clean URLs)
Disallow: /admin/
Disallow: /comment/reply/
Disallow: /filter/tips/
Disallow: /node/add/

# Paths (no clean URLs)
Disallow: /?q=admin/
Disallow: /?q=comment/reply/
Disallow: /?q=filter/tips/
Disallow: /?q=node/add/
```

## Technical Requirements

Project has been developed under **Ruby 2.1.1** using **bundler** to store and install used gems.

If you are familiar with Ruby and Bundler you can skip until the data requirements section, as there's nothing new here for you.

If you aren't experienced with Ruby here are some instructions for installing this project.

Unfortunately this instructions are for installations on a Linux (Debian or Ubuntu, in fact) as it is my work environment. I'm quite confident that this instructions may work on Mac too, but I can't guarantee it.

If you manage to install the project in other OS, please send me the instructions and I will append them here.

### GIT

Git is a distributed revision control system. You can install it using *apt* wit the following command `apt-get install git`.

Git use is only mandatory if you want to clone or fork this repository. Otherwise you can just download the ZIP file at Github repo: https://github.com/wild-fire/twitter-graph-segmenter

### RVM

First, download RVM from https://rvm.io/. RVM is a Ruby Version Manager that allows you to easily install rubies in your machine. I personally love it :)

If you don't want to read all the website just type in bash `curl -sSL https://get.rvm.io | bash`.

### Ruby 2.1.1

Once you have installed RVM, installing Ruby 2.1.1 is as easy as typing `rvm install 2.1.1`

## Installing the scripts

### Downloading the code

You can fork or clone this repo to download the code. If you don't want to use GIT then you can just download the zip file from Github.

### Setting Up RVM and installing gems

Enter your code directory and run `rvm use 2.1.1@twitter-graph-segmenter --create --ruby-version`. This will create a RVM gemset and set this folder pointing to that gemset.

Now you can run `bundle install` and install all the required gems. If you receive an error because `bundle` is not recognized just run `gem install bundler` and then `bundle install`

## Executing the scripts

This repo have just one script run by typing `bin/first_tweet.rb` with two commands (`user` and `users`).

`user` command receives the name of a user and displays in the standard output its first tweet. (i.e. `bin/first_tweet.rb user SciencePorn`)

`users` command receives a file in TSV format with user ids, names and signup dates and stores in a TSV file the id, date, user id and tweet text of the first tweet of each user.

## Data requuirements

### Users file

`users` command uses a file with information about the users whose first tweet we want to fetch.

An example of that file would be

```
47  kellan  2006-03-24 04:13:02 +0100
70  shannon 2006-04-01 21:30:51 +0200
96  garo  2006-04-09 19:31:28 +0200
108 ilona 2006-04-14 08:42:02 +0200
```

Since the `users` command only use the users name to retrieve its first tweet, first and third column doesn't need to be accurate at all.

## Data Output

### Tweets file

`users` command stores its results in a TSV file with 4 columns: tweet id, tweet date, user id and tweet text.

```
230 2006-03-24 04:13:02 +0100 47  just setting up my twitter
870 2006-04-01 21:30:51 +0200 70  just setting up my twitter
2123  2006-04-14 08:42:02 +0200 108 just setting up my twitter
```

## Contribute

You can fork the repo and do any modification you want (including documentation). Then make a pull request so I can consider its inclusion in my repo.

You can also discuss anything in the issues section. Any comment will be appreciated.
