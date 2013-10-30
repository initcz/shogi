#
# Figure class
#
class Figure
  constructor: (@id, @type, @owner, @x, @y) ->
    @id = null if not id?
    @type = null if not type?
    @owner = null if not owner?
    @x = null if not x?
    @y = null if not y?
    @promoted = false

factory = ->
  return Figure

if typeof define is 'function' and define.amd
  define [], factory
else if typeof exports is 'object'
  module.exports = factory()
else
  this.Figure = factory()

## End
