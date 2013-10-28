/*
 * see https://github.com/requirejs/require-cs
 *
 * [D3.js]
 *
 * https://github.com/mbostock/d3/pull/745
 *
 * http://stackoverflow.com/questions/13157704/how-to-integrate-d3-with-require-js
 * https://groups.google.com/forum/#!topic/d3-js/PSPKF8V0D00
 *
 * [Zepto.js] - used only ajax module
 *
 * https://github.com/madrobby/zepto/pull/342
 * http://blog.jquery.com/2013/04/18/jquery-2-0-released/
 *
 * http://stackoverflow.com/questions/13425815/how-to-use-requirejs-with-zepto
 * http://simonsmith.io/using-zepto-and-jquery-with-requirejs/
 */

requirejs.config({
  baseUrl: "js/lib",
  paths: {
    d3: 'd3',
    zepto: 'zepto.ajax.min',
    less: 'less.min',
    EventEmitter: 'EventEmitter.min',
    app: '../app',
    ui: '../ui'
  },
  shim: {
    d3: {
      exports: 'd3'
    },
    zepto: {
      exports: 'Zepto'
    }
  }
});

require(['less', 'cs!app/csmain']);
