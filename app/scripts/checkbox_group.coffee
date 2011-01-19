class window.CheckboxGroup
  constructor: (@name, @callback) ->
    @template = Handlebars.compile("{{#values}}<p><input name=\"#{@name}\" type=\"checkbox\" value=\"{{.}}\"</input>{{.}}</p>{{/values}}")
    @div = $("##{@name}")

  create: (json) ->
    @div.append @template json
    @application_filter = $("[name=\"#{@name}\"]")
    @application_filter.bind 'change', (event) => @app_filter_button_clicked()

  app_filter_button_clicked: ->
    @callback(@application_filter.map -> @value if @checked)

