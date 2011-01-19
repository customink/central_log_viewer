String::trimToNull = ->
  val = $.trim(this)
  if 0 == val.length then null else val

class window.LogViewerHandler
  constructor: (@data_url, @app_url) ->
    @tail_frequency = 5000
    @listing_table = $('#log_listing')
    @query_button = $('#run_query')
    @clear_button = $('#clear_log_listing')
    @fields_input = $('#fields')
    @query_input = $('#query')
    @query_time = $('#query_time')
    @tail_checkbox = $('#tail')
    @record_count = $('#record_count')
    @progress_bar = $('#progress')

    @data_grid = new SimpleDataGrid @listing_table, @fields_input.val().trimToNull()
    @application_checkbox = new CheckboxGroup('application_filter', (data) => @app_filter_button_clicked(data))
    @query_builder = new MongoQueryBuilder()

    @bind_controls()
    @init_controls()

  bind_controls: ->
    @query_button.bind 'click', (event) => @query_button_clicked()
    @clear_button.bind 'click', (event) => @clear_button_clicked()

  init_controls: ->
    $.getJSON(@app_url, (data) => @application_checkbox.create(data))

  query_button_clicked: ->
    @data_grid.empty()
    query = @query_input.val().trimToNull()
    if query?
      start = new Date()
      @progress_bar.css('display', 'inline-block')
      params = if @tail_checkbox[0].checked then {query: query, tail: 1} else {query: query}
      $.getJSON(@data_url, params, (data) => @refresh_grid(data, query, start))

  requery: (start) ->
    setTimeout((() =>
      @query_builder.set_tail_filter @data_grid.last_pk
      query = @query_builder.generate()
      $.getJSON(@data_url, {query: query}, (data) => @tail_grid(data, query, start))
    ), @tail_frequency)

  tail_grid: (data, query, start) ->
    @data_grid.append_data data
    @requery_decision start

  refresh_grid: (data, query, start) ->
    fields = @fields_input.val().trimToNull()
    @data_grid.refresh_data(data, fields)
    @requery_decision start

  requery_decision: (start) ->
    elapsed = new Date() - start
    @set_status(start, elapsed)
    if @tail_checkbox[0].checked
      @requery start
    else
      @query_builder.set_tail_filter null
      @progress_bar.css('display', 'none')

  set_status: (start, elapsed) ->
    @query_time.text "#{start.toString().substr(4,20)} (#{elapsed}ms)"
    @record_count.text "#{@data_grid.record_count} Record#{if @data_grid.record_count is 1 then '' else 's'}"

  clear_button_clicked: ->
    @data_grid.empty()
    @query_builder.clear_filters()

  # callback from checkbox group instance
  app_filter_button_clicked: (data) ->
    @query_builder.set_application_filter data
    @query_input.val @query_builder.generate()
