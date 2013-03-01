externalResource = require('./externalResource').ExternalResource

class HypemResource extends externalResource
  constructor: (@_obj = {}) ->
    @mediaid = @_obj.mediaid if @_obj.mediaid
    @_id = @_obj._id if @_obj._id

  mediaid: null


exports.HypemResource = HypemResource
