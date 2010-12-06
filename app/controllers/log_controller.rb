# REVERT BACK TO AVOID LOGGING SELF!!! class LogController < ActionController::Base
class LogController < ApplicationController
  respond_to :json, :html

  #@records = collection.find({}, :skip => offset, :limit => count, :sort => [[ '_id', :desc ]])
  def index
    logger = Rails.logger
    @collection = logger.mongo_connection[logger.mongo_collection_name]

    query = params[:query] || 'find({}).limit(20)'
    # scary, yet powerful
    respond_with(eval('@collection.' + query))
  end
end
