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
        (event) ->
          Observable.create (observable) ->
            do (listener = observable.onNext.bind observable) ->
              if event?
                source.addEventListener event, listener
              else
                source.onmessage = listener
            ->                                  # return a cleanup function
              source.close()
      ]
