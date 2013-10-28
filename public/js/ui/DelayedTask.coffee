define([
  'exports'
], (exports) ->
  class DelayedTask
    constructor: (@fn, @defaultDelay) ->

    delay: (delay) ->
      @cancel()
      delay = @defaultDelay if not delay?
      @timeoutId = setTimeout(@_onTimeout, delay)

    cancel: ->
      clearTimeout(@timeoutId) if @timeoutId?
      delete @timeoutId

    _onTimeout: =>
      delete @timeoutId
      @fn()

  exports.DelayedTask = DelayedTask
)
