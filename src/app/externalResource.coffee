###ExternalResource = (resource) ->
  if resource
    for key, value of resource
      console.log(key)
      this[key] = value if value
###
SimpleClass = require('./simpleClass').SimpleClass

class ExternalResource extends SimpleClass
  constructor: (@_obj = {}) ->

exports.ExternalResource = ExternalResource
