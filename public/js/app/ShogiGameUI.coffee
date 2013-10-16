#
# AMD support
#
# This class make sense only for browser
# see https://github.com/umdjs/umd/blob/master/amdWeb.js
#

factory = (ShogiGame) ->

  class ShogiGameUI

    constructor: ->
      @game = new ShogiGame()
      @game.initUI 'content'

  return ShogiGameUI

if typeof define is 'function' and define.amd
  # AMD. Register as an anonymous module.
  define ['cs!app/ShogiGame'], factory
else
  # Browser globals ('this' is window)
  this.ShogiGameUI = factory(this.ShogiGame)

## End
