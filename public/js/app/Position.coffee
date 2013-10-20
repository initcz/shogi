# help method
patt = new RegExp '#?x([0-8])y([0-8])'
parseId = (id) ->
  result = patt.exec id
  data =
    x: parseInt result[1], 10
    y: parseInt result[2], 10

#
# Position class
#
class Position
    constructor: (@x, @y) ->
      if not y? and 'string' is typeof x
        data = parseId @x
        @x = data.x
        @y = data.y
    getFigure: (board) ->
      f = board[@x][@y]
      if f is undefined
        return null
      else
        return f
    getSelector: (hash = true) ->
      return Position.createSelector @x, @y, hash
    @createSelector: (x, y, hash = true) ->
      id = "x#{x}y#{y}"
      if hash
        return '#' + id
      else
        return id

factory = ->
  return Position

if typeof define is 'function' and define.amd
  define [], factory
else if typeof exports is 'object'
  module.exports = factory()
else
  this.Figure = factory()

## End
