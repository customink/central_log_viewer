String::trimToNull = ->
  val = $.trim(this)
  if 0 == val.length then null else val

class window.LogViewerHandler
  constructor: (@data_url, @app_url) ->
    @listing_table = $('#log_listing')
    @query_button = $('#run_query')
    @clear_button = $('#clear_log_listing')
    @fields_input = $('#fields')
    @query_input = $('#query')
    @query_time = $('#query_time')
    @record_count = $('#record_count')

    @data_grid = new SimpleDataGrid @listing_table, @fields_input.val().trimToNull()
    @application_checkbox = new CheckboxGroup('application_filter', (data) => @app_filter_button_clicked(data))
    @query_builder = new MongoQueryBuilder()
    @bind_controls()
    $.getJSON(@app_url, (data) => @application_checkbox.create(data))

  bind_controls: ->
    @query_button.bind 'click', (event) => @query_button_clicked()
    @clear_button.bind 'click', (event) => @clear_button_clicked()

  query_button_clicked: ->
    query = @query_input.val().trimToNull()
    if query?
      start = new Date()
      $.getJSON(@data_url, {query: query}, (data) => @refresh_grid(data, start))

  refresh_grid: (data, start) ->
    fields = @fields_input.val().trimToNull()
    @data_grid.refresh_data(data, fields)
    elapsed = new Date() - start
    @set_status(start, elapsed)

  set_status: (start, elapsed) ->
    @query_time.text "#{start.toString().substr(4,20)} (#{elapsed}ms)"
    @record_count.text @data_grid.record_count

  clear_button_clicked: ->
    alert "clear button clicked"

  app_filter_button_clicked: (data) ->
    @query_builder.add_application_filter data
    @query_input.val @query_builder.generate()
# validate fields input?
