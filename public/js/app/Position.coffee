#
# Position class
#
class Position
    constructor: (@x, @y) ->
    getFigure: (board) ->
      f = board[@x][@y]
      if f is undefined
        return null
      else
        return f
    equalsTo: (position) ->
      if not position instanceof Position
        throw new Error 'not Position argument'
      return false if @x isnt position.x
      return false if @y isnt position.y
      return true

factory = -> Position
if typeof define is 'function' and define.amd
  define [], factory
else if typeof exports is 'object'
  module.exports = factory()
else
  this.Position = factory()

## End
