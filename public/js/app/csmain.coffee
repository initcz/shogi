define([
  'cs!ui/ShogiGameController'
], (ShogiGameController) ->
  controller = new ShogiGameController({
    animate: true
  })

  controller.initialize()
  controller.start()
)
