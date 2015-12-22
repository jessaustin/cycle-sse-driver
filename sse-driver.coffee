# copyright (c) 2015 Jess Austin <jess.austin@gmail.com>
# released under MIT License

{Observable: {create, fromCallback}} = require 'rx'

module.exports = ->
  (url$) ->
    url$.map (url) ->
      source = new EventSource url

      events$ = create (observable) ->
        source.onmessage = (event) ->
          observable.onNext event
        ->                  # cleanup
          source.close()

      events$.events = (event) ->
        fromCallback(source.addEventListener) event

      [url, events$]
