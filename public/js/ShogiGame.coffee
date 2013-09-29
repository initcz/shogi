#
# defining constants
#

constant =

  # RPC constants
  action:
    RESET:   0
    MOVE:    1
    PROMOTE: 2

  figureType:
    KING: 0
    GOLDEN_GENERAL: 1
    SILVER_GENERAL: 2
    BISHOP: 3 # (shooter)
    ROOK: 4
    LANCE: 5 # warrior with spear
    KNIGHT: 6
    PAWN: 7

  owner:
    A: 0
    B: 1

  misc:
    BOARD_SIZE: 9

#
# Figure class
#
class Figure
  constructor: (@type, @owner) ->
    @promoted = false

#
# Main class
#

## TODO: mind UI and CORE separation

class ShogiGame

  constructor: ->
    @initFigures()
    @resetBoard()
    # TODO: init communication

  # TODO: pedy - finish this, pls
  _possibleMoves: (x, y) ->
    ret = []
    #ret.push {x: 0, y: 0}

  _getClass: (figure) ->
    return '' if not figure?

    if figure.owner is constant.owner.A
      suffix = '-a'
    else
      suffix = '-b'

    if figure.type is constant.figureType.LANCE
      return 'lance' + suffix

    if figure.type is constant.figureType.KNIGHT
      return 'knight' + suffix

    if figure.type is constant.figureType.SILVER_GENERAL
      return 'silver_general' + suffix

    if figure.type is constant.figureType.GOLDEN_GENERAL
      return 'golden_general' + suffix

    if figure.type is constant.figureType.KING
      return 'king' + suffix

    if figure.type is constant.figureType.BISHOP
      return 'bishop' + suffix

    if figure.type is constant.figureType.ROOK
      return 'rook' + suffix

    if figure.type is constant.figureType.PAWN
      return 'pawn' + suffix

    return 'xxx'

  # TODO: put this in another class
  initUI: (id) =>

    html = '<table class="shogi">'
    cellId = ''
    figureClass = ''

    `
    for (var i=0; i<constant.misc.BOARD_SIZE; i++) {
      html += '<tr>';
      for (var j=0; j<constant.misc.BOARD_SIZE; j++) {
        cellId = 'R' + i + 'C' + j;
        figureClass = this._getClass(this.board[i][j]); // !!!
        html += '<td id="' + cellId + '" class="' + figureClass + '"></td>';
      }
      html += '</tr>';
    }
    `

    html += '</table>'

    # TODO: add dependency to zepto/jquery

    obj = $('#' + id)
    obj.append html


    patt = new RegExp '#?R([0-8])C([0-8])'
    parseId = (id) ->
      result = patt.exec id
      data =
        x: result[1]
        y: result[2]

    lastPositionSelector = null
    obj.on 'click', 'td', (e) =>
      o = e.target

      # TODO: show possible places to move by calling @_possibleMoves

      coordinates = parseId o.id

      figure = @board[coordinates.x][coordinates.y]

      if lastPositionSelector?
        $(lastPositionSelector).toggleClass('selected')

        # move figure to empty place
        if not figure?
          lastCoordinates = parseId lastPositionSelector
          @board[coordinates.x][coordinates.y] = @board[lastCoordinates.x][lastCoordinates.y]
          @board[lastCoordinates.x][lastCoordinates.y] = null
          @redrawUI() # XXX

      if figure?
        $(o).toggleClass('selected')
        lastPositionSelector = '#' + o.id
      else
        lastPositionSelector = null

  redrawUI: (putFigures = true) ->
    cell = null
    figure = null

    `
    for (var i=0; i<constant.misc.BOARD_SIZE; i++) {
      for (var j=0; j<constant.misc.BOARD_SIZE; j++) {
        cell = $('#R' + i + 'C' + j);
        cell.removeClass();
        if (putFigures) {
          figure = this.board[i][j];
          if (figure != null) {
            cell.addClass(this._getClass(figure));
          }
        }
      }
    }
    `

    # ugly Coffee hack - `` can't be last in func, because of return
    return true

  initFigures: ->

    @figures = []

    # Figures for owner A
    @figures[0] = new Figure constant.figureType.LANCE, constant.owner.A
    @figures[1] = new Figure constant.figureType.KNIGHT, constant.owner.A
    @figures[2] = new Figure constant.figureType.SILVER_GENERAL, constant.owner.A
    @figures[3] = new Figure constant.figureType.GOLDEN_GENERAL, constant.owner.A
    @figures[4] = new Figure constant.figureType.KING, constant.owner.A
    @figures[5] = new Figure constant.figureType.GOLDEN_GENERAL, constant.owner.A
    @figures[6] = new Figure constant.figureType.SILVER_GENERAL, constant.owner.A
    @figures[7] = new Figure constant.figureType.KNIGHT, constant.owner.A
    @figures[8] = new Figure constant.figureType.LANCE, constant.owner.A
    @figures[9] = new Figure constant.figureType.BISHOP, constant.owner.A
    @figures[10] = new Figure constant.figureType.ROOK, constant.owner.A
    @figures[11] = new Figure constant.figureType.PAWN, constant.owner.A
    @figures[12] = new Figure constant.figureType.PAWN, constant.owner.A
    @figures[13] = new Figure constant.figureType.PAWN, constant.owner.A
    @figures[14] = new Figure constant.figureType.PAWN, constant.owner.A
    @figures[15] = new Figure constant.figureType.PAWN, constant.owner.A
    @figures[16] = new Figure constant.figureType.PAWN, constant.owner.A
    @figures[17] = new Figure constant.figureType.PAWN, constant.owner.A
    @figures[18] = new Figure constant.figureType.PAWN, constant.owner.A
    @figures[19] = new Figure constant.figureType.PAWN, constant.owner.A

    # Figures for owner B
    @figures[20] = new Figure constant.figureType.LANCE, constant.owner.B
    @figures[21] = new Figure constant.figureType.KNIGHT, constant.owner.B
    @figures[22] = new Figure constant.figureType.SILVER_GENERAL, constant.owner.B
    @figures[23] = new Figure constant.figureType.GOLDEN_GENERAL, constant.owner.B
    @figures[24] = new Figure constant.figureType.KING, constant.owner.B
    @figures[25] = new Figure constant.figureType.GOLDEN_GENERAL, constant.owner.B
    @figures[26] = new Figure constant.figureType.SILVER_GENERAL, constant.owner.B
    @figures[27] = new Figure constant.figureType.KNIGHT, constant.owner.B
    @figures[28] = new Figure constant.figureType.LANCE, constant.owner.B
    @figures[29] = new Figure constant.figureType.BISHOP, constant.owner.B
    @figures[30] = new Figure constant.figureType.ROOK, constant.owner.B
    @figures[31] = new Figure constant.figureType.PAWN, constant.owner.B
    @figures[32] = new Figure constant.figureType.PAWN, constant.owner.B
    @figures[33] = new Figure constant.figureType.PAWN, constant.owner.B
    @figures[34] = new Figure constant.figureType.PAWN, constant.owner.B
    @figures[35] = new Figure constant.figureType.PAWN, constant.owner.B
    @figures[36] = new Figure constant.figureType.PAWN, constant.owner.B
    @figures[37] = new Figure constant.figureType.PAWN, constant.owner.B
    @figures[38] = new Figure constant.figureType.PAWN, constant.owner.B
    @figures[39] = new Figure constant.figureType.PAWN, constant.owner.B

  resetBoard: (putFigures = true) ->

    delete @board
    @board = []

    `
    for(var i=0; i<constant.misc.BOARD_SIZE; i++){
     this.board[i] = [];
    }
    `

    delete @offside
    @offside = []
    @offside[constant.owner.A] = []
    @offside[constant.owner.B] = []

    return if not putFigures

    # top-left corner is counted as 0,0
    # bot-left corner is counted as 8,0

    # Owner A
    @board[8][0] = @figures[0]
    @board[8][1] = @figures[1]
    @board[8][2] = @figures[2]
    @board[8][3] = @figures[3]
    @board[8][4] = @figures[4]
    @board[8][5] = @figures[5]
    @board[8][6] = @figures[6]
    @board[8][7] = @figures[7]
    @board[8][8] = @figures[8]
    @board[7][1] = @figures[9]
    @board[7][7] = @figures[10]
    @board[6][0] = @figures[11]
    @board[6][1] = @figures[12]
    @board[6][2] = @figures[13]
    @board[6][3] = @figures[14]
    @board[6][4] = @figures[15]
    @board[6][5] = @figures[16]
    @board[6][6] = @figures[17]
    @board[6][7] = @figures[18]
    @board[6][8] = @figures[19]

    # Owner B
    @board[0][0] = @figures[20]
    @board[0][1] = @figures[21]
    @board[0][2] = @figures[22]
    @board[0][3] = @figures[23]
    @board[0][4] = @figures[24]
    @board[0][5] = @figures[25]
    @board[0][6] = @figures[26]
    @board[0][7] = @figures[27]
    @board[0][8] = @figures[28]
    @board[1][1] = @figures[30] # ROOK is always on the right side of the player
    @board[1][7] = @figures[29] # BISHOP is always on the left side of the player
    @board[2][0] = @figures[31]
    @board[2][1] = @figures[32]
    @board[2][2] = @figures[33]
    @board[2][3] = @figures[34]
    @board[2][4] = @figures[35]
    @board[2][5] = @figures[36]
    @board[2][6] = @figures[37]
    @board[2][7] = @figures[38]
    @board[2][8] = @figures[39]

    # 'downgrade' all figures
    `
    for (var i=0; i<constant.misc.BOARD_SIZE; i++) {
      for (var j=0; j<constant.misc.BOARD_SIZE; j++) {
        if (this.board[i][j] != null) {
          this.board[i][j].promoted = false
        }
      }
    }
    `

    # ugly Coffee hack - `` can't be last in func, because of return
    return true

  move: ->
  promote: ->
