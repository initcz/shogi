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
    x: parseInt(result[1], 10),
    y: parseInt(result[2], 10)
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

  Position.prototype.getFigure = function(board) {
    return board[this.x][this.y];
  };

  Position.prototype.getSelector = function(hash) {
    if (hash == null) {
      hash = true;
    }
    return Position.createSelector(this.x, this.y, hash);
  };

  Position.createSelector = function(x, y, hash) {
    var id;
    if (hash == null) {
      hash = true;
    }
    id = "x" + x + "y" + y;
    if (hash) {
      return '#' + id;
    } else {
      return id;
    }
  };

  return Position;

})();

ShogiGame = (function() {
  function ShogiGame() {
    this.initUI = __bind(this.initUI, this);
    this.initFigures();
    this.resetBoard();
    this.editorMode = false;
  }

  ShogiGame.prototype._possibleMoves = function(position) {
    var figure;
    figure = position.getFigure(this.board);
    if (figure === void 0) {
      throw new Error("figure shouldn't be undefined - see stack trace and fix it!");
    }
    if (figure === null) {
      console.log('calling possibleMoves with position without figure');
      return [];
    }
    if (figure.type === constant.figureType.PAWN) {
      return this._pawnPossibleMoves(position.x, position.y);
    }
    return [];
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

  ShogiGame.prototype._validMove = function(oldPosition, newPosition) {
    var id, newFigure, position, valid, _i, _len, _ref;
    valid = false;
    id = newPosition.getSelector();
    _ref = this._possibleMoves(oldPosition);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      position = _ref[_i];
      if (id === position.getSelector()) {
        valid = true;
      }
    }
    newFigure = newPosition.getFigure(this.board);
    if (valid && (typeof oldFigure !== "undefined" && oldFigure !== null) && (newFigure != null) && oldFigure.owner === newFigure.owner) {
      valid = false;
    }
    return valid;
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
        cellId = Position.createSelector(x, y, false);
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
      var clazz, figure, move, o, position, same, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;
      o = e.target;
      obj = $(o);
      position = new Position(o.id);
      figure = position.getFigure(_this.board);
      same = false;
      if (lastPosition != null) {
        same = position.getSelector() === lastPosition.getSelector();
      }
      clazz = 'selected-figure';
      if (!same && (figure != null) && !obj.hasClass(clazz)) {
        obj.addClass(clazz);
      }
      if (lastPosition != null) {
        obj = $(lastPosition.getSelector());
        if (!same && obj.hasClass(clazz)) {
          obj.removeClass(clazz);
        }
      }
      if ((figure != null) && !same) {
        _ref = _this._possibleMoves(position);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          move = _ref[_i];
          clazz = 'possible-move';
          obj = $(move.getSelector());
          if (!obj.hasClass(clazz)) {
            obj.addClass(clazz);
          }
        }
      }
      if ((figure != null) && !same && (lastPosition != null) && (lastPosition.getFigure(_this.board) != null)) {
        _ref1 = _this._possibleMoves(lastPosition);
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          move = _ref1[_j];
          clazz = 'possible-move';
          obj = $(move.getSelector());
          if (obj.hasClass(clazz)) {
            obj.removeClass(clazz);
          }
        }
      }
      if ((lastPosition != null) && (figure == null) && !same) {
        if (_this.editorMode || _this._validMove(lastPosition, position)) {
          _this.board[position.x][position.y] = lastPosition.getFigure(_this.board);
          _this.board[lastPosition.x][lastPosition.y] = null;
          _this.redrawUI();
        } else {
          _ref2 = _this._possibleMoves(lastPosition);
          for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
            move = _ref2[_k];
            clazz = 'possible-move';
            obj = $(move.getSelector());
            if (obj.hasClass(clazz)) {
              obj.removeClass(clazz);
            }
          }
        }
        return lastPosition = null;
      } else {
        return lastPosition = position;
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
