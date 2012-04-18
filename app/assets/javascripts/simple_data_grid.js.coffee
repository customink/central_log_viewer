String::splitTrim = ->
  ($.trim f for f in this.split ',')

class window.SimpleDataGrid
  default_head_data: ["id", "request_time", "application_name", "controller", "action", "runtime", "messages"]
  rel_to_msg_mapping:
    id: "{{id_to_s}}",
    action: "{{../../action}}",
    application_name: "{{../../application_name}}",
    controller: "{{../../controller}}",
    ip: "{{../../ip}}",
    messages: "{{.}}",
    params: "{{../../",
    path: "{{../../path}}",
    request_time: "{{../../request_time}}",
    runtime: "{{../../runtime}}",
    url: "{{../../url}}"
  header_source: '<thead><tr>{{#.}}<th>{{.}}</th>{{/.}}</tr></thead>'
  data_source: '''{{#.}}{{#messages}}
                    {{#info}}{{> record}}{{/info}}
                    {{#debug}}{{> record}}{{/debug}}
                    {{#error}}{{> record}}{{/error}}
                    {{#warn}}{{> record}}{{/warn}}
                    {{#fatal}}{{> record}}{{/fatal}}
                  {{/messages}}{{/.}}'''

  constructor: (@listing_table, fields, @data) ->
    if fields?
      @fields = fields.splitTrim()
      # avoid regenerating template if fields are the same
      @old_fields_val = fields
    else
      @fields = @default_head_data
      @old_fields_val = null
    Handlebars.registerHelper "map_to_relative", (context, fn) => @map_to_relative(context, fn).join ''
    Handlebars.registerHelper "id_to_s", () -> this.__get__('../../_id')?.$oid

    @create_handlebars_templates()
    @listing_table.append @templates.header(@fields)
    @listing_table.append @templates.data(@data, @templates.partials) if @data?
    @record_count = 0

  create_handlebars_templates: ->
    # TODO: escape special chars in fields
    # TODO: get rid of double partials call
    @templates =
      header: Handlebars.compile @header_source
      data: Handlebars.compile @data_source
      record_source: Handlebars.compile '<tr id="id">{{#map_to_relative}}<td>{{.}}</td>{{/map_to_relative}}</tr>'
    @create_record_template @fields

  map_to_relative: (context, fn) ->
    #TODO: use default ../.. for all unknown contexts
    for f in context
      if 0 == f.indexOf("params")
        fn "#{@rel_to_msg_mapping["params"]}#{f.replace ".", "/"}}}"
      else
        fn "#{@rel_to_msg_mapping[f]}"

  create_record_template: (fields) ->
    source = @templates.record_source(fields).replace '"id"', "\"#{@rel_to_msg_mapping["id"]}\""
    Handlebars.registerPartial "record", source

  refresh_data: (@data, fields) ->
    if @data?
      # if nothing changed, don't recreate the record template
      if fields isnt @old_fields_val
        unless fields?
          # set back to the default fields because form field is empty
          @old_fields_val = null
          @fields = @default_head_data
        else
          # new fields to deal with
          @old_fields_val = fields
          @fields = fields.splitTrim()
        @create_record_template @fields
      @listing_table.empty()
      @listing_table.append @templates.header(@fields)
      #TODO: See how to add helper to this by inspecting
      @listing_table.append "<tbody id=\"data_grid_body\">#{@templates.data(@data)}</tbody>"
      @tbody = $('#data_grid_body')
      @update_grid_metadata(0)

  append_data: (@data) ->
    @tbody.append @templates.data(@data)
    @update_grid_metadata(@record_count)

  update_grid_metadata: (previous_length) ->
    unless @data.length?
      # single records are objects, not arrays so length doesn't exist
      @record_count = previous_length + 1
      @last_pk = @data["_id"]["$oid"]
    else if @data.length isnt 0
      @record_count = previous_length + @data.length
      @last_pk = @data[@data.length - 1]["_id"]["$oid"]

  empty: ->
    @listing_table.empty()
    @last_pk = null
    @record_count = 0
    @data = null
