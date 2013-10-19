#
# AMD support
#
# This class make sense only for browser
# see https://github.com/umdjs/umd/blob/master/amdWeb.js
#

factory = (ShogiGame) ->

  class ShogiGameUI

    constructor: ->
      @editorMode = false

      @game = new ShogiGame()
      @game.initUI 'content'

    initUI: (id) =>

      html = '<table class="shogi">'
      cellId = ''
      figureClass = ''

      `
      for (var y=(ShogiGame.constant.misc.BOARD_SIZE-1); y>=0; y--) {
        html += '<tr>';
        for (var x=0; x<ShogiGame.constant.misc.BOARD_SIZE; x++) {
          cellId = Position.createSelector(x, y, false);
          figureClass = this._getClass(this.board[x][y]).join(' '); // !!!
          html += '<td id="' + cellId + '" class="' + figureClass + '"></td>';
        }
        html += '</tr>';
      }
      `

      html += '</table>'

      # TODO: add dependency to zepto/jquery

      obj = $('#' + id)
      obj.append html

      lastPosition = null
      obj.on 'click', 'td', (e) =>

        o = e.target
        obj = $(o)
        position = new Position o.id
        figure = position.getFigure @board

        same = false
        if lastPosition?
          same = position.getSelector() is lastPosition.getSelector()

        # highlight current position
        clazz = 'selected-figure'
        if not same and figure? and not obj.hasClass clazz
          obj.addClass clazz

        # remove highlight for last position
        if lastPosition?
          obj = $(lastPosition.getSelector())
          if not same and obj.hasClass clazz
            obj.removeClass clazz

        # show possible places to move
        if figure? and not same
          for move in @_possibleMoves position
            clazz = 'possible-move'
            obj = $(move.getSelector())
            if not obj.hasClass clazz
              obj.addClass clazz

        # remove highlighted possible places to move
        if figure? and not same and lastPosition? and lastPosition.getFigure(@board)?
          for move in @_possibleMoves lastPosition
            clazz = 'possible-move'
            obj = $(move.getSelector())
            if obj.hasClass clazz
              obj.removeClass clazz

        # move figure
        if lastPosition? and not figure? and not same

          if @editorMode or @_validMove lastPosition, position
            @board[position.x][position.y] = lastPosition.getFigure @board
            @board[lastPosition.x][lastPosition.y] = null

            # TODO - 1: redraw only one figure, not whole board
            # TODO - 2: separate UI from core
            @redrawUI() # XXX

          else
            for move in @_possibleMoves lastPosition
              clazz = 'possible-move'
              obj = $(move.getSelector())
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

      `
      for (var x=0; x<ShogiGame.constant.misc.BOARD_SIZE; x++) {
        for (var y=0; y<ShogiGame.constant.misc.BOARD_SIZE; y++) {
          cell = $(Position.createSelector(x, y));
          cell.removeClass();
          if (putFigures) {
            figure = this.board[x][y];
            if (figure != null) {
              cell.addClass(this._getClass(figure).join(' '));
            }
          }
        }
      }
      `

      # ugly Coffee hack - `` can't be last in func, because of return
      return true

  return ShogiGameUI

if typeof define is 'function' and define.amd
  # AMD. Register as an anonymous module.
  define ['cs!app/ShogiGame'], factory
else
  # Browser globals ('this' is window)
  this.ShogiGameUI = factory(this.ShogiGame)

## End
