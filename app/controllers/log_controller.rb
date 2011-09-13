class LogController < AdminController
  respond_to :html, :json

  def index
    collection = Mongo.db[Mongo.collection]
    query = "collection.#{params[:query] || 'find_one()'}"
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
    respond_with(Mongo.db.command({:distinct => Mongo.collection, :key => "application_name"}) )
  end
end
