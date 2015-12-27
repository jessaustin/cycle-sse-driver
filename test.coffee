if module?
  # this "require" is OK because browserify never sees this test file
  global.EventSource = require 'eventsource'

sse = require './sse-driver'

require('tape') 'Cycle-SSE-Driver Test', (tape) ->
  port = 1337
  messages = [
    event: 'one', data: 'data one'
  ,
    event: 'two', data: 'data two'
  ,
    event: 'one', data: 'data three'
  ,
    data: 'data four'
  ]

  server = require('http').createServer (req, res) ->
    req.on 'data', -> # does nothing but is necessary
    req.on 'end', ->
      # this is SSE...
      res.writeHead 200,
        'Content-Type': 'text/event-stream'
        Connection: 'keep-alive'
        'Cache-Control': 'no-cache'
        'Transfer-Encoding': 'chunked'
      res.write "#{if message.event? then "event: #{message.event}\n" else ""}\
                data: #{message.data}\n\n" for message in messages

  server.listen port

  tape.plan 4
  source = sse("http://localhost:#{port}/")()
  one_data = messages[0].data
  source 'one'
    .subscribe ({data}) ->
      tape.equal data, one_data, 'Proper data for event type "one"'
      one_data = messages[2].data
  source 'two'
    .subscribe ({data}) ->
      tape.equal data, messages[1].data, 'Proper data for event type "two"'
  source()
    .first()                # so this will ever complete
    .subscribe ({data}) ->
      tape.equal data, messages[3].data, 'Proper data for generic message event type'
    ,
      ->
    ,
      ->
        server.close()
