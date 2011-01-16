# REVERT BACK TO AVOID LOGGING SELF!!! class LogController < ActionController::Base
class LogController < ApplicationController
  respond_to :html, :json
  #@records = collection.find({}, :skip => offset, :limit => count, :sort => [[ '_id', :desc ]])
  def index
    setup
    query = params[:query] || 'find({}).limit(20)'
    respond_with(eval('@collection.' + query))
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
