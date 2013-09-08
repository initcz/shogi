class ShogiGame
  constructor: (id) ->
    max_i = 9
    max_j = 9
    html = '<table>'
    `
    for (var i=0; i<max_i; i++) {
      html += '<tr>';
      for (var j=0; j<max_j; j++) {
        html += '<td id="R' + i + 'C' + j + '"></td>';
      }
      html += '</tr>';
    }
    `
    html += '</table>'
    $('#' + id).append html
