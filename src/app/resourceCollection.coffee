SimpleClass = require('./simpleClass').SimpleClass

class ResourceCollection extends SimpleClass
  constructor: (@_obj = {}) ->
    @_id = @_obj._id if @_obj._id
    @currentList = @_obj.currentList  if @_obj.currentList
    @savedList = @_obj.savedList  if @_obj.savedList

  currentList: new Array
  savedList: new Array

  addCurrent = (element) ->
    @currentList.push(element)

  clearCurrent = ->
    @currentList = new Array

  addSaved = (element) ->
    @savedList.push(element)

  currentToSaved = ->
    temp = new Array
    i = 0
    for item in @currentList
      temp.push({
        _id:item._id,
        order: i,
      })
      i++
    @savedList = temp

exports.ResourceCollection = ResourceCollection
