#
# AMD support
#
# This class make sense only for browser
# see https://github.com/umdjs/umd/blob/master/amdWeb.js
#

factory = (PositionUI, ShogiGame, Figure) ->

  class ShogiGameUI

    constructor: ->
      @editorMode = false
      @game = new ShogiGame()
      @game.addListener @onGameChange
      @initUI 'content'
      @offBoardElems = [
        document.getElementById('off-board-player-0')
        document.getElementById('off-board-player-1')
      ]
      @offBoardElems[0].addEventListener('click', @onOffBoardClick, false)
      @offBoardElems[1].addEventListener('click', @onOffBoardClick, false)
      @offBoardPieces = [ [], [] ]
      @offBoardPiecesCount = [0, 0]
      # function for easy testing off-boards
      window.gc = ((count, player) =>
        @onGameChange('taken', { type: i, player: if player? then player else 0 }) for i in [1...(count + 1)]
      )

    initUI: (id) =>
      html = []
      html.push('<div class="shogi-board">')
      boardSize = ShogiGame.constant.misc.BOARD_SIZE
      for y in [(boardSize - 1)..0]
        for x in [0...boardSize]
          position = new PositionUI x, y
          figureClass = @game._getClass(position.getFigure(@game.board));
          figureClass = figureClass.join(' ')
          html.push("<div id='#{position.getSelector(false)}' class='#{figureClass}'></div>")
      html.push('</div>')

      obj = $("##{id}")
      obj.append(html.join(''))

      @lastPosition = null
      obj.on 'click', '.shogi-board .field', @onShogiBoardFieldClick

    redrawUI: (putFigures = true) ->
      cell = null
      figure = null

      for x in [0...ShogiGame.constant.misc.BOARD_SIZE]
        for y in [0...ShogiGame.constant.misc.BOARD_SIZE]
          cell = $(PositionUI.createSelector(x, y))
          cell.removeClass()
          if putFigures
            figure = @game.board[x][y]
            cell.addClass @game._getClass(figure).join(' ')

    onShogiBoardFieldClick: (e) =>
      debugger
      o = e.target
      obj = $(o)
      position = new PositionUI o.id
      figure = position.getFigure @game.board

      highlight = false
      move = false

      # with previous select
      if @lastPosition?
        # do nothing when clicking on same place
        return if position.equalsTo @lastPosition

        removeHighlight = true
        if figure?
          if figure.owner is @game.currentUser
            move = false
            highlight = true
          else
            if @game._validMove @lastPosition, position
              move = true
              highlight = false
            else
              move = false
              removeHighlight = false
              highlight = false
        else
          move = true
          removeHighlight = false if not @game._validMove @lastPosition, position

        if removeHighlight
          # remove highlight for last position
          $(@lastPosition.getSelector()).removeClass('selected-figure')

          # remove highlighted possible places to move
          clazz = 'possible-move'
          $(".shogi-board .field.#{clazz}").removeClass(clazz)

      else if @selectedOffBoardFigure?
        # FIXME add validation of this action!!!
        @game.returnPiece @selectedOffBoardFigure, position
        @redrawUI()
        return
      # without previous select
      else
        if figure?
          # exit when selecting other player figure (without previous select)
          return if figure.owner isnt @game.currentUser
          highlight = true
        else
          # if not figure on last position and not current position
          return

      if move
        moveOk = @game.move @lastPosition, position, @editorMode
        if moveOk
          # TODO: redraw only one figure, not whole board
          @redrawUI() # XXX
          @lastPosition = null
          return

      if highlight
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
      @lastPosition = position if figure? and figure.owner is @game.currentUser

    onOffBoardClick: (event) =>
      piece = event.target
      if piece.classList.contains('piece')
        lastSelectedPiece = document.querySelector('.off-board .piece.selected')
        lastSelectedPiece.classList.remove('selected') if lastSelectedPiece
        piece.classList.add('selected')
        type = parseInt(piece.dataset.type)
        player = parseInt(piece.dataset.player)
        @selectedOffBoardFigure = new Figure(type, player)
        for position in @game._possiblePlacesForFigure(player, type)
          field = document.querySelector(PositionUI.createSelector(position.x, position.y))
          field.classList.add('possible-move')

    onGameChange: (event, data) =>
      console.log(event, data)
      switch event
        when 'taken'
          player = data.player
          type = data.type
          offBoardElem = @offBoardElems[player]
          pieces = @offBoardPieces[player]
          piece = pieces[type]
          if not piece?
            pieceElem = document.createElement('div')
            pieceElem.dataset.player = player
            pieceElem.dataset.type = type
            classes = @game._getClass({ owner: 0, type: type }) # FIXME temporary! we need always player-a class
            classes.push('piece')
            #pieceElem.classList.add.apply(pieceElem.classList, classes)
            pieceElem.classList.add(clazz) for clazz in classes

            offBoardPiecesCount = ++@offBoardPiecesCount[player]
            beforePiece = offBoardElem.querySelector(".piece:nth-child(#{Math.ceil(offBoardPiecesCount / 2)})")
            if offBoardPiecesCount isnt 1
              offBoardElem.insertBefore(pieceElem, beforePiece)
            else
              offBoardElem.appendChild(pieceElem)

            piece =
              el: pieceElem
              count: 0
            pieces[type] = piece
          else
            pieceElem = pieces[type].el

          piece.count += 1
          pieceElem.classList.add('show-count') if piece.count > 1
          pieceElem.dataset.count = piece.count
          if piece.count is 1
            setTimeout(=>
              offBoardPiecesCount = @offBoardPiecesCount[player]
              offBoardElem.classList.remove("pieces-#{offBoardPiecesCount - 1}")
              offBoardElem.classList.add("pieces-#{offBoardPiecesCount}")
            , 0) # plan animation to the next loop
        when 'returned'
          # FIXME validation?
          delete @selectedOffBoardFigure
          player = data.figure.owner
          type = data.figure.type
          offBoardElem = @offBoardElems[player]
          pieces = @offBoardPieces[player]
          piece = pieces[type]
          if piece?
            pieceElem = piece.el
            piece.count--
            if piece.count is 0
              offBoardPiecesCount = --@offBoardPiecesCount[player]
              offBoardElem.classList.remove("pieces-#{offBoardPiecesCount + 1}")
              offBoardElem.classList.add("pieces-#{offBoardPiecesCount}") if offBoardPiecesCount > 0
              offBoardElem.removeChild(pieceElem)
              delete pieces[type]
            else
              pieceElem.classList.remove('selected')
              pieceElem.classList.remove('show-count') if piece.count is 1
              pieceElem.dataset.count = piece.count


  return ShogiGameUI

if typeof define is 'function' and define.amd
  # AMD. Register as an anonymous module.
  define ['cs!app/PositionUI','cs!app/ShogiGame', 'cs!app/Figure'], factory
else
  # Browser globals ('this' is window)
  this.ShogiGameUI = factory(this.PositionUI, this.ShogiGame, this.Figure)

## End
