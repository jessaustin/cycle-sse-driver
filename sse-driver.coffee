# copyright (c) 2015 Jess Austin <jess.austin@gmail.com>
# released under MIT License

# Cycle.js driver for Server-Sent Events (SSE), also known as EventSource.

{Observable: {create}} = require 'rx'

module.exports = (url) ->
  source = new EventSource url
  ->
    (event) ->    # function from event name to a stream of events of that type
      create (observable) ->
        do (listener = observable.onNext.bind observable) ->
          if event?
            source.addEventListener event, listener
          else
            source.onmessage = listener
        source.onerror = (err) ->
          # with any other readyState, EventSource will keep trying
          observable.onError err if err.target.readyState is EventSource.CLOSED
        ->                   # XXX should we really return a cleanup function?
          source.close()
