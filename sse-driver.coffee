###
Copyright (c) 201{5,6} Jess Austin <jess.austin@gmail.com>
Released under MIT License

Cycle.js driver for Server-Sent Events, also known as EventSource.
###

{Observable: {create}} = require 'rx'

module.exports = (url) ->
  source = new EventSource url
  ->              # this is a source not a sink, so we don't care about args
    (event) ->    # function from event name to a stream of events of that type
      create (observable) ->
        listener = observable.onNext.bind observable
        if event?
          source.addEventListener event, listener
        else
          source.onmessage = listener
        source.onerror = observable.onError.bind observable # XXX does this do anything?
        source.close.bind source # XXX should we really return a cleanup function?
