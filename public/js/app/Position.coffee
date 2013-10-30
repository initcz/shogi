#
# Position class
#
class Position
    constructor: (@x, @y) ->
    getFigureId: (board) ->
      id = board[@x][@y]
      if id?
        return id
      else
        return null

    getFigure: (board, figures) ->
      id = board[@x][@y]
      if id?
        return figures[id]
      else
        return null

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
