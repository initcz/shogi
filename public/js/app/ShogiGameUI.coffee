#
# AMD support
#
# This class make sense only for browser
# see https://github.com/umdjs/umd/blob/master/amdWeb.js
#

factory = (PositionUI, ShogiGame) ->

  class ShogiGameUI

    constructor: ->
      @editorMode = false

      listener = (event, data) ->
        console.log event, data # XXX

      @game = new ShogiGame()
      @game.addListener listener
      @initUI 'content'

    initUI: (id) =>

      html = '<table class="shogi">'
      for y in [(ShogiGame.constant.misc.BOARD_SIZE-1)..0]
        html += '<tr>'
        for x in [0...ShogiGame.constant.misc.BOARD_SIZE]
          position = new PositionUI x, y
          figureClass = @game._getClass(position.getFigure(@game.board)).join(' ')
          html += '<td id="' + position.getSelector(false) + '" class="' + figureClass + '"></td>'
        html += '</tr>'
      html += '</table>'

      obj = $('#' + id)
      obj.append html

      lastPosition = null
      obj.on 'click', 'td', (e) =>

        o = e.target
        obj = $(o)
        position = new PositionUI o.id
        figure = position.getFigure @game.board

        # who's turn it is?
        return if figure isnt null and figure.owner isnt @game.currentUser and lastPosition is null

        if lastPosition?
          same = position.equalsTo lastPosition
        else
          same = false

        # highlight current position
        clazz = 'selected-figure'
        if not same and figure? and not obj.hasClass clazz
          obj.addClass clazz

        # remove highlight for last position
        if lastPosition?
          obj = $(lastPosition.getSelector())
          if not same and obj.hasClass clazz
            obj.removeClass clazz

        # remove highlighted possible places to move
        if figure? and not same and lastPosition? and lastPosition.getFigure(@game.board)?
          clazz = 'possible-move'
          $("td.#{clazz}").removeClass(clazz)

        # show possible places to move
        if figure? and not same
          for p in @game._possibleMoves position
            movePosition = new PositionUI p
            clazz = 'possible-move'
            obj = $(movePosition.getSelector())
            if not obj.hasClass clazz
              obj.addClass clazz

        # move figure
        if lastPosition? and not same

          moveOk = @game.move lastPosition, position, @editorMode
          if moveOk

            # TODO - 1: redraw only one figure, not whole board
            # TODO - 2: separate UI from core
            @redrawUI() # XXX

          else
            for p in @game._possibleMoves lastPosition
              movePosition = new PositionUI p
              clazz = 'possible-move'
              obj = $(movePosition.getSelector())
              if obj.hasClass clazz
                obj.removeClass clazz

          #delete lastPosition
          lastPosition = null

        else
          # save last position
          lastPosition = position

    redrawUI: (putFigures = true) ->
      cell = null
      figure = null

      for x in [0...ShogiGame.constant.misc.BOARD_SIZE]
        for y in [0...ShogiGame.constant.misc.BOARD_SIZE]
          cell = $(PositionUI.createSelector(x, y))
          cell.removeClass()
          if putFigures
            figure = @game.board[x][y]
            if figure isnt null
              cell.addClass @game._getClass(figure).join(' ')

  return ShogiGameUI

if typeof define is 'function' and define.amd
  # AMD. Register as an anonymous module.
  define ['cs!app/PositionUI','cs!app/ShogiGame'], factory
else
  # Browser globals ('this' is window)
  this.ShogiGameUI = factory(this.PositionUI, this.ShogiGame)

## End
