TAIL_RECORDS = 40

class LogController < ApplicationController
  respond_to :html, :json

  def index
    setup
    query = "@collection.#{params[:query] || 'find_one()'}"
    if params[:tail] && !query.include?("find_one")
      # find_one does not support skip.
      # The skip is only used the first time someone requests tail
      count = eval("#{query}.count()")
      skip = count <= TAIL_RECORDS ? 0 : count - TAIL_RECORDS
      query = "#{query}.skip(#{skip}) "
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
