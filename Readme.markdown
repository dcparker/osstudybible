# Start Sinatra with Cilantro!

Cilantro is a structured starter-app built on Sinatra. It comes with a daemon manager script as well (see below).
Cilantro uses a basic structure similar to Rails, with controllers, models, and views folders in the app directory.
A config, lib and public directories are also used, as may be familiar to you. All ruby files in the lib directory
are require'd, as are all controllers and optionally, all models. A simple rendering engine is included for your
convenience, but as it is very simple you are free to enhance it as you like.

Beyond this structure, it's all Sinatra. For your models, you are free to use whatever you like: DataMapper,
ActiveRecord, or anything else. It's up to you. There are no walls, and this server is *very* fast.

## Features:

+ Rubygems sandboxing (only gems in the ./gems folder are accessible, IF a ./gems folder is present)
+ Automatically installing any missing sandboxed gems (this is a really fast process) when you run the app
+ Really fast startup time (sub 1 second) and really fast request processing
+ Optional auto-reloading of the application when app files are modified
+ An explicit [currently haml-only] templating system
+ A "cilantro new" command (which builds a new app) as well as "cilantro update" that will update cilantro underneath your development project's edits.

# bin/cilantro

+ You'll want to put this script somewhere into your PATH, such as /usr/local/bin.

### Create a new Cilantro app:

    cilantro new app_name

### Update Cilantro in a Cilantro app:

From within the app directory:

    cilantro update

Or, from outside, run:

    cilantro update /path/to/app

### Run a Cilantro app:

From within the app directory, run:

    cilantro

Or, from outside, run:

    cilantro /path/to/app

Cilantro will run on port 5000 by default, but you can add --port NUMBER if you want.

### Start a Cilantro app daemon:

Again, from within the directory:

    cilantro start

Or, from outside, run:

    cilantro start /path/to/app

Cilantro will look for a config/cilantro.yml, and if this yml config contains a :port list, it will start a daemon for each of the ports specified.

### Stop a Cilantro app daemon:

From within the app directory:

    cilantro stop

Or from outside:

    cilantro stop /path/to/app

### Check the status of services for an app:

From within the app directory:

    cilantro status

From outside:

    cilantro status /path/to/app

Cilantro will report on the number of services that are running, and their port numbers.

### Tips 'n Tricks

Put the following in your ~/.irbrc file:

    load '/etc/irbrc'

    if File.exists?('lib/cilantro.rb')
      require 'lib/cilantro'
      Cilantro.load_environment(:irb)
    end

This will pre-load your app environment whenever you run irb in a cilantro app directory.
