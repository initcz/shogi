// Generated by CoffeeScript 1.6.3
var Figure, ShogiGame, constant;

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

ShogiGame = (function() {
  function ShogiGame() {
    this.board = [];
    
    for(var i=0;i<constant.misc.BOARD_SIZE;i++){
     this.board[i] = [];
    }
    ;
    this.figures = [];
    this.offside = [];
    this.offside[constant.owner.A] = [];
    this.offside[constant.owner.B] = [];
    this.init();
  }

  ShogiGame.prototype.initUI = function(id) {
    var cellId, html, max_i, max_j;
    max_i = 9;
    max_j = 9;
    html = '<table>';
    cellId = '';
    
    for (var i=0; i<max_i; i++) {
      html += '<tr>';
      for (var j=0; j<max_j; j++) {
        cellId = 'R' + i + 'C' + j;
        html += '<td id="' + cellId + '">' + cellId + '</td>';
      }
      html += '</tr>';
    }
    ;
    html += '</table>';
    return $('#' + id).append(html);
  };

  ShogiGame.prototype.init = function() {
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
    this.figures[39] = new Figure(constant.figureType.PAWN, constant.owner.B);
    return this.reset();
  };

  ShogiGame.prototype.reset = function() {
    this.board[8][0] = this.figures[0];
    this.board[8][1] = this.figures[1];
    this.board[8][2] = this.figures[2];
    this.board[8][3] = this.figures[3];
    this.board[8][4] = this.figures[4];
    this.board[8][5] = this.figures[5];
    this.board[8][6] = this.figures[6];
    this.board[8][7] = this.figures[7];
    this.board[8][8] = this.figures[8];
    this.board[7][1] = this.figures[9];
    this.board[7][7] = this.figures[10];
    this.board[6][0] = this.figures[11];
    this.board[6][1] = this.figures[12];
    this.board[6][2] = this.figures[13];
    this.board[6][3] = this.figures[14];
    this.board[6][4] = this.figures[15];
    this.board[6][5] = this.figures[16];
    this.board[6][6] = this.figures[17];
    this.board[6][7] = this.figures[18];
    this.board[6][8] = this.figures[19];
    this.board[0][0] = this.figures[20];
    this.board[0][1] = this.figures[21];
    this.board[0][2] = this.figures[22];
    this.board[0][3] = this.figures[23];
    this.board[0][4] = this.figures[24];
    this.board[0][5] = this.figures[25];
    this.board[0][6] = this.figures[26];
    this.board[0][7] = this.figures[27];
    this.board[0][8] = this.figures[28];
    this.board[1][1] = this.figures[30];
    this.board[1][7] = this.figures[29];
    this.board[2][0] = this.figures[31];
    this.board[2][1] = this.figures[32];
    this.board[2][2] = this.figures[33];
    this.board[2][3] = this.figures[34];
    this.board[2][4] = this.figures[35];
    this.board[2][5] = this.figures[36];
    this.board[2][6] = this.figures[37];
    this.board[2][7] = this.figures[38];
    return this.board[2][8] = this.figures[39];
  };

  ShogiGame.prototype.move = function() {};

  ShogiGame.prototype.promote = function() {};

  return ShogiGame;

})();
