module.exports = (store) ->
  store.query.expose 'resources', 'forGroup', (group) ->
    @where('group').equals(group)
