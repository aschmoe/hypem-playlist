request = require 'request'

class HypemConnector

  constructUrl = (type, id, page) ->
    core = 'http://hypem.com/playlist/'
    mid = '/json/'
    end = 'data.js'

    switch type
      when 'track'
        url = core + 'item/' + id + mid + end

      when 'favorites'
        url = core + 'loved/' + id + mid + page + '/' + end

    url

  requestUrl = (id, callback) ->
    console.log(this.constructUrl('track', id, 1))
    request.get {url:this.constructUrl('track', id, 1), json:true}, (error, response, body) ->
      if(error)
        callback(error)

      else if (response.statusCode == 200)
        callback(null, body)

      else
        callback('Sorry, something went amis')

exports.HypemConnector = HypemConnector
