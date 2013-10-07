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

patt = new RegExp '#?x([0-8])y([0-8])'
parseId = (id) ->
  result = patt.exec id
  data =
    x: parseInt result[1], 10
    y: parseInt result[2], 10

#
# Position class
#
class Position
    constructor: (@x, @y) ->
      if not y? and 'string' is typeof x
        data = parseId @x
        @x = data.x
        @y = data.y
    getFigure: (board) ->
      return board[@x][@y]
    getSelector: (hash = true) ->
      return Position.createSelector @x, @y, hash
    @createSelector: (x, y, hash = true) ->
      id = "x#{x}y#{y}"
      if hash
        return '#' + id
      else
        return id

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
    if @board[x][y].type is constant.figureType.PAWN
      return this._pawnPossibleMoves(x, y)
    #ret = []
    #ret.push {x: 0, y: 0}

  _pawnPossibleMoves: (x, y) ->
    ret = []
    if @board[x][y].owner is constant.owner.A
      ret.push new Position x, y+1
    else
      ret.push new Position x, y-1
    return ret

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
    for (var y=(constant.misc.BOARD_SIZE-1); y>=0; y--) {
      html += '<tr>';
      for (var x=0; x<constant.misc.BOARD_SIZE; x++) {
        cellId = Position.createSelector(x, y, false);
        figureClass = this._getClass(this.board[x][y]); // !!!
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

      if lastPosition?
        # remove highlight for last position
        obj = $(lastPosition.getSelector())
        if not same and obj.hasClass clazz
          obj.removeClass clazz

        # TODO: show possible places to move by calling @_possibleMoves

      # move figure
      if lastPosition? and not figure? and not same
        @board[position.x][position.y] = lastPosition.getFigure @board
        @board[lastPosition.x][lastPosition.y] = null
        @redrawUI() # XXX

        #delete lastPosition
        lastPosition = null

      else
        # save last position
        lastPosition = position

  redrawUI: (putFigures = true) ->
    cell = null
    figure = null

    `
    for (var x=0; x<constant.misc.BOARD_SIZE; x++) {
      for (var y=0; y<constant.misc.BOARD_SIZE; y++) {
        cell = $(Position.createSelector(x, y));
        cell.removeClass();
        if (putFigures) {
          figure = this.board[x][y];
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

    #0,8             8,8
    # _ _ _ _ _ _ _ _ _
    #|_|_|_|_|_|_|_|_|_|
    #|_|_|_|_|_|_|_|_|_|
    #|_|_|_|_|_|_|_|_|_|
    #|_|_|_|_|_|_|_|_|_|
    #|_|_|_|_|_|_|_|_|_|
    #|_|_|_|_|_|_|_|_|_|
    #|_|_|_|_|_|_|_|_|_|
    #|_|_|_|_|_|_|_|_|_|
    #|_|_|_|_|_|_|_|_|_|
    #0,0             8,0

    # Owner A
    @board[0][0] = @figures[0]
    @board[1][0] = @figures[1]
    @board[2][0] = @figures[2]
    @board[3][0] = @figures[3]
    @board[4][0] = @figures[4]
    @board[5][0] = @figures[5]
    @board[6][0] = @figures[6]
    @board[7][0] = @figures[7]
    @board[8][0] = @figures[8]
    @board[1][1] = @figures[9]
    @board[7][1] = @figures[10]
    @board[0][2] = @figures[11]
    @board[1][2] = @figures[12]
    @board[2][2] = @figures[13]
    @board[3][2] = @figures[14]
    @board[4][2] = @figures[15]
    @board[5][2] = @figures[16]
    @board[6][2] = @figures[17]
    @board[7][2] = @figures[18]
    @board[8][2] = @figures[19]

    # Owner B
    @board[0][8] = @figures[20]
    @board[1][8] = @figures[21]
    @board[2][8] = @figures[22]
    @board[3][8] = @figures[23]
    @board[4][8] = @figures[24]
    @board[5][8] = @figures[25]
    @board[6][8] = @figures[26]
    @board[7][8] = @figures[27]
    @board[8][8] = @figures[28]
    @board[1][7] = @figures[30] # ROOK is always on the right side of the player
    @board[7][7] = @figures[29] # BISHOP is always on the left side of the player
    @board[0][6] = @figures[31]
    @board[1][6] = @figures[32]
    @board[2][6] = @figures[33]
    @board[3][6] = @figures[34]
    @board[4][6] = @figures[35]
    @board[5][6] = @figures[36]
    @board[6][6] = @figures[37]
    @board[7][6] = @figures[38]
    @board[8][6] = @figures[39]

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
