#
# Figure class
#
class Figure
  constructor: (@type, @owner) ->
    @promoted = false

patt = new RegExp '#?x([0-8])y([0-8])'
parseId = (id) ->
  result = patt.exec id
  data =
    x: parseInt result[1], 10
    y: parseInt result[2], 10

factory = ->
  return Figure

if typeof define is 'function' and define.amd
  define [], factory
else if typeof exports is 'object'
  module.exports = factory()
else
  this.Figure = factory()

## End
