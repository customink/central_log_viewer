# Synopsis

The central log viewer provides a straightforward interface for viewing log data from the central logger.

1. [find()](http://api.mongodb.org/ruby/current/Mongo/Collection.html#find-instance_method) queries using the mongo driver API
2. grep functionality using find({"key" => /regexp/}) queries
3. tail -f behavior
4. A configurable listing

# Installation

1. git clone git://github.com/customink/central_log_viewer.git
2. brew install coffee-script # 1.0 is required
3. cd central_log_viewer
4. cp config/database.yml.sample config/database.yml
5. Configure database.yml to point to your mongo db log.  See the [central_logger](http://github.com/customink/central_logger) README for configuration options and defaults.
6. bundle install

# Usage

1. The following columns can be specified in the "Listing Fields" text area, separated by comma:
        action
        application_name
        controller
        ip
        messages
        params.<key>
        path
        request_time
        runtime
        url

2. Other parameters in a logged request can be specified using the "<code>params.&lt;key&gt;</code>" format.
3. Checking Tail -f will execute the query every second, appending a <code>{"_id" => {"$gt" => ObjectId("last_object_id")}}</code> clause to the query

# Log Viewer Authentication
If you want to enable HTTP Digest Authentication then
1. cp config/auth.yml.sample config/auth.yml
2. Edit the username and password in it according to your needs

# Code Overview

This is a Rails 3 application that uses the central_logger gem to configure the mongo driver.  A single trivial controller eval()'s the find
query and returns JSON to the client for formatting by Handlebars templates. BistroCar is used to dynamically generate JS from
several CoffeeScript classes in app/scripts.

# Dependencies

* Ruby 1.9.2 (rvm recommended)
* Git 1.6+
* Bundler 1.0+ for dependency management
* CoffeeScript 1.0 (Node.js dep)
* bistro_car
* haml/sass

# Deployment

# Author

[Alex Stupka](https://github.com/astupka)

Copyright (c) 2011 CustomInk, released under the MIT license
