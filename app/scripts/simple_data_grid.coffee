String::splitTrim = ->
  ($.trim f for f in this.split ',')

class window.SimpleDataGrid
  default_head_data: ["id", "messages", "action", "request_time", "controller"]
  rel_to_msg_mapping:
    id: "../../_id",
    action: "../../action",
    application_name: "../../application_name",
    controller: "../../controller",
    ip: "../../ip",
    messages: ".",
    params: "../../",
    path: "../../path",
    request_time: "../../request_time",
    runtime: "../../runtime",
    url: "../../url"
  header_source: '<thead><tr>{{#.}}<th>{{.}}</th>{{/.}}</tr></thead>'
  data_source: '''<tbody>{{#.}}{{#messages}}
                    {{#info}}{{> record}}{{/info}}
                    {{#debug}}{{> record}}{{/debug}}
                    {{#error}}{{> record}}{{/error}}
                    {{#warn}}{{> record}}{{/warn}}
                    {{#fatal}}{{> record}}{{/fatal}}
                  {{/messages}}{{/.}}</tbody>'''

  constructor: (@listing_table, fields, @data) ->
    if fields?
      @fields = fields.splitTrim()
      # avoid regenerating template if fields are the same
      @old_fields_val = fields
    else
      @fields = @default_head_data
      @old_fields_val = null

    @create_handlebars_templates()
    @listing_table.append @templates.header(@fields)
    @listing_table.append @templates.data(@data, @templates.partials) if @data?

  create_handlebars_templates: ->
    # TODO: escape special chars in fields
    # TODO: get rid of double partials call
    @templates =
      header: Handlebars.compile @header_source
      data: Handlebars.compile @data_source
      helpers:
        map_to_relative:
          (context) => @map_to_relative context
      record_source: Handlebars.compile "<tr id=\"#{@rel_to_msg_mapping["id"]}\">{{#.}}<td>{{map_to_relative .}}</td>{{/.}}</tr>"
      partials:
        partials:
          record: null

    @templates.partials.partials.record = @create_record_template @fields

  map_to_relative: (context) ->
    if 0 == context.indexOf("params")
      "{{#{@rel_to_msg_mapping["params"]}#{context.replace ".", "/"}}}"
    else
      "{{#{@rel_to_msg_mapping[context]}}}"

  create_record_template: (fields) ->
    source = @templates.record_source fields, @templates.helpers
    @templates.partials.partials.record = Handlebars.compile source

  refresh_data: (@data, fields) ->
    if @data?
      if fields? and fields isnt @old_fields_val
        @old_fields_val = fields
        @fields = fields.splitTrim()
        @create_record_template(@fields)
      @listing_table.empty()
      @listing_table.append @templates.header(@fields)
      @listing_table.append @templates.data(@data, @templates.partials)
