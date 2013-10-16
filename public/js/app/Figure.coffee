#
# Figure class
#
class Figure
  constructor: (@type, @owner) ->
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
