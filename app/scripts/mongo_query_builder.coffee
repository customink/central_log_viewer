class window.MongoQueryBuilder
  # find({:application_name => {"$in" => ["log_viewer"]}}).limit(3)

  # this probably should be configurable (generated js struct?)
  constructor: (@current_query) ->
    Handlebars.registerHelper 'formatArray', (context) -> "\"#{i}\"" for i in context
    #TODO: make the handlebars query composition more elemental
    @query_template = Handlebars.compile 'find({ {{{.}}} })'
    # open & close tag is the only syntax that parses correctly the second time
    @app_template = Handlebars.compile ':application_name => {"$in" => [{{#formatArray}}{{.}}{{/formatArray}}]}'
    @order_id_template = Handlebars.compile ':params.id => "{{.}}"'
    # TODO: need to change actual find to only return debug messages
    @severity_template = Handlebars.compile '"messages.{{.}}" => {"$exists" => true}'
    @contains_template = Handlebars.compile '"messages.{{severity}}" => /{{contains}}/'
    @templates =
      application: [@app_template, null]
      order_id: [@order_id_template, null]
      severity: [@severity_template, null]
      contains: [@contains_template, null]

  add_filter: (key, value) ->
    @templates[key][1] = value

  add_application_filter: (value) ->
    @add_filter 'application', value

  generate: ->
    # filter = @app_template option for option in options if @options.applications?
    filters = []
    for own key, value of @templates
      filters.push value[0](value[1]) if value[1]?
    @query_template filters.join ','
