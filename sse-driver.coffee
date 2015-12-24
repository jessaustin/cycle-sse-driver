# copyright (c) 2015 Jess Austin <jess.austin@gmail.com>
# released under MIT License

{Observable} = require 'rx'

# from a stream of URLs, generate a stream of [URL, function] pairs
# the function returns streams of events
module.exports = ->
  (url$) ->
    url$.map (url) ->
      source = new EventSource url

      [
        url
        (event=null) ->
          Observable.create (observable) ->
            listener = (event) ->               # necessary due to 'this' scope
              observable.onNext event
            if event?
              source.addEventListener event, listener
            else
              source.onmessage = listener
            ->                                  # return a cleanup function
              source.close()
      ]
