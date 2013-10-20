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

        highlight = false
        move = false

        # with previous select
        if lastPosition?

          # do nothing when clicking on same place
          return if position.equalsTo lastPosition

          # last position is stored only when figure is there, and it's ours
          lastFigure = lastPosition.getFigure @game.board

          removeHighlight = true

          if figure?

            if figure.owner is @game.currentUser
              #console.log 'ours - switch' # XXX
              move = false
              highlight = true
            else
              #console.log 'others - move?' # XXX
              if @game._validMove lastPosition, position
                move = true
                highlight = false
                #console.log 'valid!' # XXX
              else
                #console.log 'NOT valid!' # XXX
                move = false
                removeHighlight = false
                highlight = false
          else
            move = true
            removeHighlight = false if not @game._validMove lastPosition, position

          if removeHighlight

            # remove highlight for last position
            $(lastPosition.getSelector()).removeClass('selected-figure')

            # remove highlighted possible places to move
            clazz = 'possible-move'
            $("td.#{clazz}").removeClass(clazz)

        # without previous select
        else

          if figure?

            # exit when selecting other player figure (without previous select)
            return if figure.owner isnt @game.currentUser

            #console.log 'highlight' # XXX
            highlight = true

          else
            #console.log 'nothing!' # XXX

            # if not figure on last position and not current position
            return

        if move
          #console.log 'move!' # XXX
          moveOk = @game.move lastPosition, position, @editorMode
          if moveOk

            # TODO: redraw only one figure, not whole board
            @redrawUI() # XXX

            #console.log 'move ok!'
            lastPosition = null
            return

          ###
          else
            console.log 'move NOT ok!'
          ###

        if highlight
          #console.log 'highlight!' # XXX

          # highlight current position
          clazz = 'selected-figure'
          obj.addClass clazz if figure? and not obj.hasClass clazz

          # show possible places to move
          if figure?
            for p in @game._possibleMoves position
              movePosition = new PositionUI p
              clazz = 'possible-move'
              obj = $(movePosition.getSelector())
              if not obj.hasClass clazz
                obj.addClass clazz

        # store only location with figures and only our own
        lastPosition = position if figure? and figure.owner is @game.currentUser

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
