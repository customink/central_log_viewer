class window.LogViewerHandler
  constructor: (listing_table_id, query_button_id, clear_button_id, fields_input_id, query_input_id, @data_url) ->
    @listing_table = $("\##{listing_table_id}")
    @query_button = $("\##{query_button_id}")
    @clear_button = $("\##{clear_button_id}")
    @fields_input = $("\##{fields_input_id}")
    @query_input = $("\##{query_input_id}")

    @data_grid = new SimpleDataGrid @listing_table, @fields_input.value
    @query_button.bind 'click', (event) => @query_button_clicked()
    @clear_button.bind 'click', (event) => @clear_button_clicked()

  query_button_clicked: ->
    alert "query button clicked"
    $.get(@data_url, {query: @query_input.val()}, (data) => @data_received(data)) if @query_input.val()?

  clear_button_clicked: ->
    alert "clear button clicked"

  data_received: (data) ->
    alert "receiving a load..."
    alert "data: #{data}" if data?

# bind event handlers to buttons
# delegate to data grid
# validate fields input?
