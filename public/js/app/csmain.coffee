define [
  'raphael',
  'cs!app/ShogiGame'
], (raphael, shogi) ->
  console.log 'hello AMD world!'
  console.log raphael
  console.log shogi
  shogi.initUI()
