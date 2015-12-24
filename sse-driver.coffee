# copyright (c) 2015 Jess Austin <jess.austin@gmail.com>
# released under MIT License

# Cycle.js driver for Server-Sent Events, also known as EventSource. The driver
# is a sink for streams of SSE URLs, and a source for streams of pairs of SSE
# URLs and functions from event names to streams of such events. When called
# with no event name the streams will be of generic "message" events.

{Observable: {create}} = require 'rx'

module.exports = ->           # the makeSSEDriver() function takes no arguments
  (url$) ->
    url$.map (url) ->
      source = new EventSource url      # XXX probably need error handling here
      [
        url         # give back the same URL that was passed in
        (event) ->  # plus a function from event name to a stream of such events
          create (observable) ->
            do (listener = observable.onNext.bind observable) ->
              if event?
                source.addEventListener event, listener
              else
                source.onmessage = listener
            ->                                  # return a cleanup function
              source.close()
      ]
