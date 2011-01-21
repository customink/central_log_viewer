class LogController < ApplicationController
  respond_to :html, :json

  def index
    setup
    query = "@collection.#{params[:query] || 'find_one()'}"
    tail_lines = params[:tail].to_i

    if 0 != tail_lines && query.include?(".find(")
      # find_one does not support skip.
      count = eval("#{query}.count()")
      if count > tail_lines
        skip = count - tail_lines
        query = "#{query}.skip(#{skip})"
      end
    end

    respond_with(eval(query))
  end

  def apps
    setup
    respond_with(@db.command({:distinct => logger.mongo_collection_name, :key => "application_name"}) )
  end

  def setup
    @db = logger.mongo_connection
    @collection = @db[logger.mongo_collection_name]
  end
end
