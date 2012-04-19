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
    @contains_template = Handlebars.compile '''"$or" => [{"messages.info" => /{{.}}/},
                                                         {"messages.debug" => /{{.}}/},
                                                         {"messages.error" => /{{.}}/},
                                                         {"messages.warn" => /{{.}}/},
                                                         {"messages.fatal" => /{{.}}/}]'''
    @tail_template = Handlebars.compile '"_id" => { "$gt" =>BSON::ObjectId("{{.}}") }'
    @templates =
      application: [@app_template, null]
      order_id: [@order_id_template, null]
      severity: [@severity_template, null]
      contains: [@contains_template, null]
      tail: [@tail_template, null]

  add_filter: (key, value) ->
    @templates[key][1] = value

  set_application_filter: (value) ->
    @add_filter 'application', value

  set_tail_filter: (value) ->
    @add_filter 'tail', value

  set_contains_filter: (value) ->
    @add_filter 'contains', value

  clear_filters: ->
    for own key, value of @templates
      value[1] = null

  generate: ->
    # filter = @app_template option for option in options if @options.applications?
    @filters = []
    for own key, value of @templates
      @filters.push value[0](value[1]) if value[1]?
    @query_template @filters.join ','
