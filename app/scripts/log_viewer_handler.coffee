String::trimToNull = ->
  val = $.trim(this)
  if 0 == val.length then null else val

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
    fields = @fields_input.val().trimToNull()
    query = @query_input.val().trimToNull()
    if query?
      $.get(@data_url, {query: query}, (data) => @data_grid.refresh_data(data, fields)) if @query_input.val()?

  clear_button_clicked: ->
    alert "clear button clicked"

# validate fields input?
