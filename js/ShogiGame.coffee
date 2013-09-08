class ShogiGame
  constructor: (id, wsUri) ->

    max_i = 9
    max_j = 9
    html = '<table>'
    cellId = ''
    `
    for (var i=0; i<max_i; i++) {
      html += '<tr>';
      for (var j=0; j<max_j; j++) {
        cellId = 'R' + i + 'C' + j;
        html += '<td id="' + cellId + '">' + cellId + '</td>';
      }
      html += '</tr>';
    }
    `
    html += '</table>'
    $('#' + id).append html

    @_ws = new WebSocket wsUri

    @_ws.onopen = (evt) ->
      console.log '[open]'
      console.log evt

    @_ws.onclose = (evt) ->
      console.log '[close]'
      console.log evt

    @_ws.onmessage = (evt) ->
      console.log '[msg]'
      console.log evt.data

    @_ws.onerror = (evt) ->
      console.log '[err]'
      console.log evt
