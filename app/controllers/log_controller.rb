class LogController < ApplicationController
  respond_to :html, :json
  def index
    logger.debug("calling index")

    setup
    query = "@collection.#{params[:query] || 'find_one()'}"
    if params[:tail] && !query.include?("find_one")
      # find_one does not support skip. This is only called once
      count = eval("#{query}.count()")
      skip = count <= 20 ? 0 : count - 20
      query = "#{query}.skip(#{skip}) "
    end

    respond_with(eval(query))
  end

  def apps
    setup
    respond_with(@db.command({:distinct => "development_log", :key => "application_name"}) )
  end

  def setup
    @db = Rails.logger.mongo_connection
    @collection = @db[logger.mongo_collection_name]
  end
end
