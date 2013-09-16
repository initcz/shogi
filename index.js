var Hapi = require('hapi');

// Create a server with a host and port
var server = Hapi.createServer('0.0.0.0', 9000);

server.route({
  method: 'GET',
  path: '/{path*}',
  handler: {
    directory: { path: './public', listing: false, index: true }
  }
});

server.start(function() {
    console.log('Started at ' + server.info.uri);
});
