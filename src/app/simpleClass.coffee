Function::define = (prop, desc) ->
  Object.defineProperty this.prototype, prop, desc

class SimpleClass
  constructor: (@_obj = {}) ->
    @_id = @_obj._id if @_obj._id

  @define 'obj'
    get: ->
      return @_obj
    set: (value) ->
      @_obj = value

  _obj: null
  _id: null


exports.SimpleClass = SimpleClass
