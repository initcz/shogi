class ShogiGame
  constructor: (id) ->
    max_i = 9
    max_j = 9
    html = '<table>'
    cellId = ''
    `
    for (var i=0; i<max_i; i++) {
      html += '<tr>';
      for (var j=0; j<max_j; j++) {
        cellId = 'R' + i + 'C' + j;
        html += '<td id="' + cellId + '">' + cellId + '</td>';
      }
      html += '</tr>';
    }
    `
    html += '</table>'
    $('#' + id).append html
