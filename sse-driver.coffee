###
Copyright (c) 201{5,6} Jess Austin <jess.austin@gmail.com>
Released under MIT License

Cycle.js driver for Server-Sent Events, also known as EventSource.
###

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
        ->                   # XXX should we really return a cleanup function?
          source.close()
