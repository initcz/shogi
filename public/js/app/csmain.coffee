define [
  'cs!app/ShogiGameUI'
], (ShogiGameUI) ->
  ui = new ShogiGameUI()
  this.shogiUI = ui
  this.shogi = ui.game
