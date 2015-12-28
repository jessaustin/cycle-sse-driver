# cycle-sse-driver

[![NPM][npmjs-img]][npmjs-url]
[![Build Status][travis-img]][travis-url]
[![Coverage Status][cover-img]][cover-url]
[![Dependency Status][david-img]][david-url]
[![Dev Dependency Status][david-dev-img]][david-dev-url]

**cycle-sse-driver** is a [Cycle.js][cycle] [driver][driver] for [Server-Sent
Events]( //html.spec.whatwg.org/multipage/comms.html#server-sent-events) (SSE),
a browser feature also known as [EventSource](
//developer.mozilla.org/en-US/docs/Web/API/EventSource). Server-Sent Events
allow the server to continuously update the page with new events, without
resorting to hacks like long-polling.

## Example

The driver function should be called with an SSE URL. In the following code,
assume reasonably-defined `view()` and `model()` functions:
```javascript
makeSSEDriver = require('cycle-sse-driver');

function intent(responses) {
  return {
    input$: responses.DOM.select('input').events('input'),
    eventOne$: responses.SSE('one'),
    eventTwo$: responses.SSE('two'),
    genericMessage$: responses.SSE()
  }
}

Cycle.run(function(responses) {
  var vtree$ = view(model(intent(responses)));
  return { DOM: vtree$ };
}, { DOM: makeDOMDriver('#myId'),
     SSE: makeSSEDriver('/sse-url') });
```
As demonstrated above, the response function may be called with an event type,
in which case only events of that type will be streamed. If the response
function is called with no arguments, generic messages (i.e. messages sent
without an `event` field) will be streamed. Since **cycle-sse-driver** is a
*source* driver, the "main" function passed to `Cycle.run()` need not return an
object with an `SSE` member.

Like other [Cycle.js][cycle] [drivers][driver], the best way to use
**cycle-sse-driver** is with [browserify](//www.npmjs.com/package/browserify).

## Thanks!

**cycle-sse-driver** is by Jess Austin and is distributed under the terms of the
[MIT License](http://opensource.org/licenses/MIT). Any and all potential
contributions of issues and pull requests are welcome!

[cycle]: //cycle.js.org
[driver]: //cycle.js.org/drivers.html
[npmjs-img]: https://badge.fury.io/js/cycle-sse-driver.svg
[npmjs-url]: //www.npmjs.org/package/cycle-sse-driver "npm Registry"
[travis-img]: https://travis-ci.org/jessaustin/cycle-sse-driver.svg?branch=master
[travis-url]: //travis-ci.org/jessaustin/cycle-sse-driver "Travis"
[cover-img]: https://coveralls.io/repos/jessaustin/cycle-sse-driver/badge.svg
[cover-url]: //coveralls.io/github/jessaustin/cycle-sse-driver "Coveralls"
[david-img]: https://david-dm.org/jessaustin/cycle-sse-driver.svg
[david-url]: //david-dm.org/jessaustin/cycle-sse-driver "David"
[david-dev-img]: https://david-dm.org/jessaustin/cycle-sse-driver/dev-status.svg
[david-dev-url]: //david-dm.org/jessaustin/cycle-sse-driver#info=devDependencies
  "David for devDependencies"
