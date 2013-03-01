derby = require 'derby'
{get, view, ready} = derby.createApp module
#require './pages'
#console.log(pages)
#require './new'
hypemResource = require('./hypemResource').HypemResource
resCollection = require('./resourceCollection').ResourceCollection
hypemConnector = require('./hypemConnector').HypemConnector
connector = new hypemConnector()
derby.use(require '../../ui')


view.fn 'noItems',
  get: (list) -> !list.length unless list is undefined
  set: ->

view.fn 'oneItem',
  get: (list) -> list.length == 1 unless list is undefined

## ROUTES ##

start = +new Date()

pages =
  home:
    title: 'Home'
    href: '/'
  new:
    title: 'New Playlist'
    href: '/new'
  submit:
    title: 'Submit form'
    href: '/submit'

###
['get', 'post', 'put', 'del'].forEach (method) ->
  [method] pages.submit.href, (page, model, {body, query}) ->
    args = JSON.stringify {method, body, query}, null, '  '
    page.render 'submit', {args}
###

get '/', (page, model) ->
  page.render 'index'

get pages.new.href, (page) ->
  # Redirect the visitor to a random resource list
  page.redirect '/' + parseInt(Math.random() * 1e9).toString(36)

# Sets up the model, the reactive function for stats and renders the todo list
get '/:groupName', (page, model, {groupName}) ->
  model.query('resources').forGroup(groupName).subscribe ->
    model.set '_groupName', groupName

    model.ref '_list.all', model.filter('resources')
      .where('group').equals(groupName)
    ###
    model.ref '_list.completed', model.filter('resources')
      .where('group').equals(groupName)
      .where('completed').equals(true)

    model.ref '_list.active', model.filter('resources')
      .where('group').equals(groupName)
      .where('completed').notEquals(true)
    ###

    # model.set '_filter', 'all'
    # model.ref '_list.shown', '_list', '_filter'
        # XXX 2012-12-04 Calling .get on keyed ref returns getter fn.
        # We used to use the above keyed ref on _list, but when
        # using derby master, it results in
        # https://github.com/codeparty/derby/issues/179
    model.ref '_list.shown', '_list.all'

    page.render 'group'

# Transitional route for enabling a filter
get from: '/:groupName', to: '/:groupName/:filterName',
  forward: (model, {filterName}) ->
    model.ref '_list.shown', "_list.#{filterName}"
  back: (model, params) ->
    model.ref '_list.shown', "_list.all"

get from: '/:groupName/:filterName', to: '/:groupName/:filterName',
  forward: (model, {filterName}) ->
    model.ref '_list.shown', "_list.#{filterName}"

## CONTROLLER FUNCTIONS ##

ready (model) ->
  resources = model.at 'resources'
  newResource = model.at '_newResource'

  exports.add = ->
    # Don't add a blank resource
    text = newResource.get().trim()
    newResource.set ''
    return unless text
    resources.add text: text, group: model.get('_groupName')

  exports.del = (e, el) ->
    # Derby extends model.at to support creation from DOM nodes
    resources.del model.at(el).get('id')

  exports.clearCompleted = ->
    for {id} in model.get('_list.completed')
      resources.del id

  exports.clickToggleAll = ->
    value = !!model.get('_list.active.length')
    for {id} in model.get('_list.all')
      resources.set id + '.completed', value

  exports.submitEdit = (e, el) ->
    el.firstChild.blur()

  exports.startEdit = (e, el) ->
    item = model.at(el)
    item.set '_editing', true

  exports.endEdit = (e, el) ->
    item = model.at(el)
    item.set '_editing', false
    if item.get('text').trim() == ''
      resources.del item.get('id')
