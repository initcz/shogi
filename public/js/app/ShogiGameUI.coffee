#
# This class make sense only for browser
#

class ShogiGameUI

  constructor: ->

#
# AMD support
#
# see https://github.com/umdjs/umd/blob/master/amdWeb.js
#

factory = (raphael, ShogiGame) ->
  console.log raphael
  console.log ShogiGame
  return ShogiGameUI

if typeof define is 'function' and define.amd
  # AMD. Register as an anonymous module.
  define ['raphael','cs!app/ShogiGame'], factory
else
  # Browser globals ('this' is window)
  this.ShogiGameUI = factory()

## End
