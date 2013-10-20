# help method
patt = new RegExp '#?x([0-8])y([0-8])'
parseId = (id) ->
  result = patt.exec id
  data =
    x: parseInt result[1], 10
    y: parseInt result[2], 10

#
# PositionUI class
#

factory = (Position) ->

  class PositionUI extends Position
      constructor: (x, y) ->
        if not y?
          if typeof x is 'string'
            data = parseId x
            x = data.x
            y = data.y
          if x instanceof Position
            p = x
            x = p.x
            y = p.y
        super x, y
      getSelector: (hash = true) ->
        return PositionUI.createSelector @x, @y, hash
      @createSelector: (x, y, hash = true) ->
        id = "x#{x}y#{y}"
        if hash
          return '#' + id
        else
          return id

if typeof define is 'function' and define.amd
  define ['cs!app/Position'], factory
else if typeof exports is 'object'
  Position = require __dirname + '/Position'
  module.exports = factory Position
else
  this.PositionUI = factory this.Position

## End
