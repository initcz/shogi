define([
  'exports'
  'd3'
  'EventEmitter'
  'cs!ui/DelayedTask'
], (exports, d3, EventEmitter, DelayedTask) ->
  class Board extends EventEmitter
    constructor: (config) ->
      { @fieldCountPerRow, @marginPercent } = config

      @fields = []
      @positionToIndex = {}
      for y in [(@fieldCountPerRow - 1)..0]
        for x in [0...@fieldCountPerRow]
          @positionToIndex["#{x},#{y}"] = @fields.length
          @fields.push({ x: x, y: y })

      @fieldElems = d3.select('#board').selectAll('div')
          .data(@fields)
        .enter().append('div').classed('field', true)
          .attr('id', (data) -> "x#{data.x}y#{data.y}") # maybe we don't need id because data are directly bound to elements
          .on('click', @onFieldClick)

      @resizeTask = new DelayedTask(@onWindowResize, 200)
      window.addEventListener('resize', => @resizeTask.delay())

      @boardStyleEl = document.querySelector('#board-style')

    highlight: (currentPosition, positions) ->
      # TODO optimize it! use d3 filter or map or something to set data in batch?
      @unhighlight()
      @_highlightField(currentPosition, 'selected')
      @_highlightField(position, 'possible') for position in positions
      @fieldElems
        .classed('selected', (data) -> data.highlightAs is 'selected')
        .classed('possible', (data) -> data.highlightAs is 'possible')
      @_updateFieldElems()

    _highlightField: (position, highlightAs) ->
      index = @positionToIndex["#{position.x},#{position.y}"]
      field = @fields[index]
      field.highlightAs = highlightAs

    unhighlight: ->
      for field in @fields
        delete field.highlightAs
      @_updateFieldElems()

    _updateFieldElems: ->
      @fieldElems
        .classed('selected', (data) -> data.highlightAs is 'selected')
        .classed('possible', (data) -> data.highlightAs is 'possible')

    onFieldClick: (data) => @emit('fieldClick', data)

    prepare: -> @onWindowResize(null) # make an initial resize

    resize: (boardSize, fieldSize, @margins) ->
      boardCss = [
        "#board { width: #{boardSize}px; height: #{boardSize}px; margin-left: #{margins.left}px; margin-top: #{margins.top}px; border-bottom: 1px solid black; }"
        "#board .field { width: #{fieldSize}px; height: #{fieldSize}px; }"
      ]
      @boardStyleEl.innerHTML = '' # clean element up
      @boardStyleEl.appendChild(document.createTextNode(boardCss.join(' ')))

    onWindowResize: () =>
      viewportWidth = document.documentElement.clientWidth
      viewportHeight = document.documentElement.clientHeight

      @boardSize = Math.floor(Math.min(viewportWidth, viewportHeight) * (1 - 2 * @marginPercent / 100))
      @fieldSize = Math.round(@boardSize / @fieldCountPerRow)
      @boardSize = @fieldSize * @fieldCountPerRow
      @margins =
        left: Math.round((viewportWidth - @boardSize) / 2)
        top: Math.round((viewportHeight - @boardSize) / 2)

      @resize(@boardSize, @fieldSize, @margins)
      @emit('boardResize', { boardSize: @boardSize, fieldSize: @fieldSize, margins: @margins })

  exports.Board = Board
)
