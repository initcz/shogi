// Generated by CoffeeScript 1.6.3
var Figure, Position, ShogiGame, constant, parseId, patt,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

constant = {
  action: {
    RESET: 0,
    MOVE: 1,
    PROMOTE: 2
  },
  figureType: {
    KING: 0,
    GOLDEN_GENERAL: 1,
    SILVER_GENERAL: 2,
    BISHOP: 3,
    ROOK: 4,
    LANCE: 5,
    KNIGHT: 6,
    PAWN: 7
  },
  owner: {
    A: 0,
    B: 1
  },
  misc: {
    BOARD_SIZE: 9
  }
};

Figure = (function() {
  function Figure(type, owner) {
    this.type = type;
    this.owner = owner;
    this.promoted = false;
  }

  return Figure;

})();

patt = new RegExp('#?x([0-8])y([0-8])');

parseId = function(id) {
  var data, result;
  result = patt.exec(id);
  return data = {
    x: result[1],
    y: result[2]
  };
};

Position = (function() {
  function Position(x, y) {
    var data;
    this.x = x;
    this.y = y;
    if ((y == null) && 'string' === typeof x) {
      data = parseId(this.x);
      this.x = data.x;
      this.y = data.y;
    }
  }

  Position.prototype.getSelector = function() {
    return "#x" + this.x + "y" + this.y;
  };

  return Position;

})();

ShogiGame = (function() {
  function ShogiGame() {
    this.initUI = __bind(this.initUI, this);
    this.initFigures();
    this.resetBoard();
  }

  ShogiGame.prototype._possibleMoves = function(x, y) {
    var ret;
    return ret = [];
  };

  ShogiGame.prototype._pawnPossibleMoves = function(x, y) {
    var ret;
    ret = [];
    if (this.board[x][y].owner === constant.owner.A) {
      ret.push(new Position(x, y + 1));
    } else {
      ret.push(new Position(x, y - 1));
    }
    return ret;
  };

  ShogiGame.prototype._getClass = function(figure) {
    var suffix;
    if (figure == null) {
      return '';
    }
    if (figure.owner === constant.owner.A) {
      suffix = '-a';
    } else {
      suffix = '-b';
    }
    if (figure.type === constant.figureType.LANCE) {
      return 'lance' + suffix;
    }
    if (figure.type === constant.figureType.KNIGHT) {
      return 'knight' + suffix;
    }
    if (figure.type === constant.figureType.SILVER_GENERAL) {
      return 'silver_general' + suffix;
    }
    if (figure.type === constant.figureType.GOLDEN_GENERAL) {
      return 'golden_general' + suffix;
    }
    if (figure.type === constant.figureType.KING) {
      return 'king' + suffix;
    }
    if (figure.type === constant.figureType.BISHOP) {
      return 'bishop' + suffix;
    }
    if (figure.type === constant.figureType.ROOK) {
      return 'rook' + suffix;
    }
    if (figure.type === constant.figureType.PAWN) {
      return 'pawn' + suffix;
    }
    return 'xxx';
  };

  ShogiGame.prototype.initUI = function(id) {
    var cellId, figureClass, html, lastPosition, obj,
      _this = this;
    html = '<table class="shogi">';
    cellId = '';
    figureClass = '';
    
    for (var y=(constant.misc.BOARD_SIZE-1); y>=0; y--) {
      html += '<tr>';
      for (var x=0; x<constant.misc.BOARD_SIZE; x++) {
        cellId = 'x' + x + 'y' + y;
        figureClass = this._getClass(this.board[x][y]); // !!!
        html += '<td id="' + cellId + '" class="' + figureClass + '"></td>';
      }
      html += '</tr>';
    }
    ;
    html += '</table>';
    obj = $('#' + id);
    obj.append(html);
    lastPosition = null;
    return obj.on('click', 'td', function(e) {
      var figure, o, position;
      o = e.target;
      position = new Position(o.id);
      figure = _this.board[position.x][position.y];
      if (lastPosition != null) {
        $(lastPosition.getSelector()).toggleClass('selected');
        if (figure == null) {
          _this.board[position.x][position.y] = _this.board[lastPosition.x][lastPosition.y];
          _this.board[lastPosition.x][lastPosition.y] = null;
          _this.redrawUI();
        }
      }
      if (figure != null) {
        $(o).toggleClass('selected');
        return lastPosition = position;
      } else {
        return lastPosition = null;
      }
    });
  };

  ShogiGame.prototype.redrawUI = function(putFigures) {
    var cell, figure;
    if (putFigures == null) {
      putFigures = true;
    }
    cell = null;
    figure = null;
    
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
    ;
    return true;
  };

  ShogiGame.prototype.initFigures = function() {
    this.figures = [];
    this.figures[0] = new Figure(constant.figureType.LANCE, constant.owner.A);
    this.figures[1] = new Figure(constant.figureType.KNIGHT, constant.owner.A);
    this.figures[2] = new Figure(constant.figureType.SILVER_GENERAL, constant.owner.A);
    this.figures[3] = new Figure(constant.figureType.GOLDEN_GENERAL, constant.owner.A);
    this.figures[4] = new Figure(constant.figureType.KING, constant.owner.A);
    this.figures[5] = new Figure(constant.figureType.GOLDEN_GENERAL, constant.owner.A);
    this.figures[6] = new Figure(constant.figureType.SILVER_GENERAL, constant.owner.A);
    this.figures[7] = new Figure(constant.figureType.KNIGHT, constant.owner.A);
    this.figures[8] = new Figure(constant.figureType.LANCE, constant.owner.A);
    this.figures[9] = new Figure(constant.figureType.BISHOP, constant.owner.A);
    this.figures[10] = new Figure(constant.figureType.ROOK, constant.owner.A);
    this.figures[11] = new Figure(constant.figureType.PAWN, constant.owner.A);
    this.figures[12] = new Figure(constant.figureType.PAWN, constant.owner.A);
    this.figures[13] = new Figure(constant.figureType.PAWN, constant.owner.A);
    this.figures[14] = new Figure(constant.figureType.PAWN, constant.owner.A);
    this.figures[15] = new Figure(constant.figureType.PAWN, constant.owner.A);
    this.figures[16] = new Figure(constant.figureType.PAWN, constant.owner.A);
    this.figures[17] = new Figure(constant.figureType.PAWN, constant.owner.A);
    this.figures[18] = new Figure(constant.figureType.PAWN, constant.owner.A);
    this.figures[19] = new Figure(constant.figureType.PAWN, constant.owner.A);
    this.figures[20] = new Figure(constant.figureType.LANCE, constant.owner.B);
    this.figures[21] = new Figure(constant.figureType.KNIGHT, constant.owner.B);
    this.figures[22] = new Figure(constant.figureType.SILVER_GENERAL, constant.owner.B);
    this.figures[23] = new Figure(constant.figureType.GOLDEN_GENERAL, constant.owner.B);
    this.figures[24] = new Figure(constant.figureType.KING, constant.owner.B);
    this.figures[25] = new Figure(constant.figureType.GOLDEN_GENERAL, constant.owner.B);
    this.figures[26] = new Figure(constant.figureType.SILVER_GENERAL, constant.owner.B);
    this.figures[27] = new Figure(constant.figureType.KNIGHT, constant.owner.B);
    this.figures[28] = new Figure(constant.figureType.LANCE, constant.owner.B);
    this.figures[29] = new Figure(constant.figureType.BISHOP, constant.owner.B);
    this.figures[30] = new Figure(constant.figureType.ROOK, constant.owner.B);
    this.figures[31] = new Figure(constant.figureType.PAWN, constant.owner.B);
    this.figures[32] = new Figure(constant.figureType.PAWN, constant.owner.B);
    this.figures[33] = new Figure(constant.figureType.PAWN, constant.owner.B);
    this.figures[34] = new Figure(constant.figureType.PAWN, constant.owner.B);
    this.figures[35] = new Figure(constant.figureType.PAWN, constant.owner.B);
    this.figures[36] = new Figure(constant.figureType.PAWN, constant.owner.B);
    this.figures[37] = new Figure(constant.figureType.PAWN, constant.owner.B);
    this.figures[38] = new Figure(constant.figureType.PAWN, constant.owner.B);
    return this.figures[39] = new Figure(constant.figureType.PAWN, constant.owner.B);
  };

  ShogiGame.prototype.resetBoard = function(putFigures) {
    if (putFigures == null) {
      putFigures = true;
    }
    delete this.board;
    this.board = [];
    
    for(var i=0; i<constant.misc.BOARD_SIZE; i++){
     this.board[i] = [];
    }
    ;
    delete this.offside;
    this.offside = [];
    this.offside[constant.owner.A] = [];
    this.offside[constant.owner.B] = [];
    if (!putFigures) {
      return;
    }
    this.board[0][0] = this.figures[0];
    this.board[1][0] = this.figures[1];
    this.board[2][0] = this.figures[2];
    this.board[3][0] = this.figures[3];
    this.board[4][0] = this.figures[4];
    this.board[5][0] = this.figures[5];
    this.board[6][0] = this.figures[6];
    this.board[7][0] = this.figures[7];
    this.board[8][0] = this.figures[8];
    this.board[1][1] = this.figures[9];
    this.board[7][1] = this.figures[10];
    this.board[0][2] = this.figures[11];
    this.board[1][2] = this.figures[12];
    this.board[2][2] = this.figures[13];
    this.board[3][2] = this.figures[14];
    this.board[4][2] = this.figures[15];
    this.board[5][2] = this.figures[16];
    this.board[6][2] = this.figures[17];
    this.board[7][2] = this.figures[18];
    this.board[8][2] = this.figures[19];
    this.board[0][8] = this.figures[20];
    this.board[1][8] = this.figures[21];
    this.board[2][8] = this.figures[22];
    this.board[3][8] = this.figures[23];
    this.board[4][8] = this.figures[24];
    this.board[5][8] = this.figures[25];
    this.board[6][8] = this.figures[26];
    this.board[7][8] = this.figures[27];
    this.board[8][8] = this.figures[28];
    this.board[1][7] = this.figures[30];
    this.board[7][7] = this.figures[29];
    this.board[0][6] = this.figures[31];
    this.board[1][6] = this.figures[32];
    this.board[2][6] = this.figures[33];
    this.board[3][6] = this.figures[34];
    this.board[4][6] = this.figures[35];
    this.board[5][6] = this.figures[36];
    this.board[6][6] = this.figures[37];
    this.board[7][6] = this.figures[38];
    this.board[8][6] = this.figures[39];
    
    for (var i=0; i<constant.misc.BOARD_SIZE; i++) {
      for (var j=0; j<constant.misc.BOARD_SIZE; j++) {
        if (this.board[i][j] != null) {
          this.board[i][j].promoted = false
        }
      }
    }
    ;
    return true;
  };

  ShogiGame.prototype.move = function() {};

  ShogiGame.prototype.promote = function() {};

  return ShogiGame;

})();
