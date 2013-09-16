#
# defining constants
#

constant =

  # RPC constants
  action:
    RESET:   0
    MOVE:    1
    PROMOTE: 2

  figureType:
    KING: 0
    GOLDEN_GENERAL: 1
    SILVER_GENERAL: 2
    BISHOP: 3 # FIXME - shooter?
    TOWER: 4
    JAVELINEER: 5 # warrior with spear
    RIDER: 6
    PAWN: 7

  owner:
    A: 0
    B: 1

#
# Figure class
#
class Figure
  constructor: (@type, @owner) ->
    @promoted = false

#
# Main class
#

## TODO: mind UI and CORE separation

class ShogiGame
  constructor: (wsUri) ->
    @initWS wsUri

  initWS: (wsUri) ->
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

  # TODO: put this in another class
  initUI: (id) ->

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

  reset: ->
  move: ->
  promote: ->
