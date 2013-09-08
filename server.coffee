#!/usr/bin/env coffee
WebSocketServer = require('ws').Server

port = 8080

wss = new WebSocketServer {port: port}
wss.on 'connection', (ws) ->

    ws.on 'message', (message) ->
      console.log 'received: %s', message

    ws.send('something');

console.log "listening on #{port}"
