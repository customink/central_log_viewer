class window.SimpleDataGrid
  default_head_data: ["id", "messages", "action", "request_time", "controller"]
  rel_to_msg_mapping:
    id: "../../_id",
    action: "../../action",
    application_name: "../../application_name",
    controller: "../../controller",
    ip: "../../ip",
    messages: ".",
    "params/": "../../params/",
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

  constructor: (@listing_table, @fields, @data) ->
    @fields = @default_head_data unless @fields?
    @create_handlebars_templates()
    @listing_table.append @templates.header(@fields)
    @listing_table.append @templates.data(@data, @templates.partials) if @data?

  create_handlebars_templates: ->
    # TODO: escape special chars in fields
    helpers = map_to_relative:
                (context) => '{{' + @rel_to_msg_mapping[context] + '}}'
    record_source_template = Handlebars.compile "<tr id=\"#{@rel_to_msg_mapping["id"]}\">{{#.}}<td>{{map_to_relative .}}</td>{{/.}}</tr>"
    record_source = record_source_template @fields, helpers

    @templates =
      header: Handlebars.compile @header_source
      data: Handlebars.compile @data_source
      partials:
        partials:
          record: Handlebars.compile record_source

  refresh_data: (@data) ->
    if @data?
      @listing_table.empty()
      @listing_table.append @templates.header(@fields)
      @listing_table.append @templates.data(@data, @templates.partials)
