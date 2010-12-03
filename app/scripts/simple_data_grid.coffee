class window.SimpleDataGrid
  tbody_id: '#data_grid_tbody'
  head_row_id: '#data_grid_head_row'
  label: '$label'
  label: '$data'
  templates :
    header: '<thead><tr id="#{head_row_id}"></tr></thead>
             <tbody id="#{tbody_id}"></tbody>'
    headcell: '<th>$label</th>'
    datarow: '<tr id="$id"></tr>'
    datacell: '<td>$data</td>'

  constructor: (@listing_table, @fields, @data) ->
    @listing_table.append @templates.header
    @tbody = $("\##{@tbody_id}")
    @head_row = $("\##{@head_row_id}")
    this.refresh_header @fields

  refresh_header: (@fields) ->
    if @fields?
      head += templates.headcell.replace @label field for field in @fields
      @head_row.empty
      @head_row.append head

  refresh_data: (@data) ->
    if @data?
      data += templates.headcell.replace @label field for field in @data
      @head_row.empty
      @head_row.append head
