String::trimToNull = ->
  val = $.trim(this)
  if 0 == val.length then null else val

class window.LogViewerHandler
  constructor: (@data_url) ->
    @listing_table = $('#log_listing')
    @query_button = $('#run_query')
    @clear_button = $('#clear_log_listing')
    @fields_input = $('#fields')
    @query_input = $('#query')
    @application_filter = $('[name="application_filter"]')

    @data_grid = new SimpleDataGrid @listing_table, @fields_input.val().trimToNull()
    @query_builder = new MongoQueryBuilder()
    @query_button.bind 'click', (event) => @query_button_clicked()
    @clear_button.bind 'click', (event) => @clear_button_clicked()
    @application_filter.bind 'change', (event) => @app_filter_button_clicked()

  query_button_clicked: ->
    fields = @fields_input.val().trimToNull()
    query = @query_input.val().trimToNull()
    $.get(@data_url, {query: query}, (data) => @data_grid.refresh_data(data, fields)) if query?

  clear_button_clicked: ->
    alert "clear button clicked"

  app_filter_button_clicked: ->
    # alert "app button clicked"
    @query_builder.add_application_filter @application_filter.map -> @value if @checked
    @query_input.val @query_builder.generate()
# validate fields input?
