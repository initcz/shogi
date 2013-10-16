/*
 * https://github.com/requirejs/example-jquery-shim
 */
requirejs.config({
  "baseUrl": "js/lib",
  "paths": {
    "app": "../app"
  /*
  },
  "shim": {
    "jquery.alpha": ["jquery"],
    "jquery.beta": ["jquery"]
  */
  }
});

/*
 * see https://github.com/requirejs/require-cs
 *
 * [D3.js]
 * http://stackoverflow.com/questions/13157704/how-to-integrate-d3-with-require-js
 * https://groups.google.com/forum/#!topic/d3-js/PSPKF8V0D00
 *
 * [Zepto.js] - necessary when we want to use D3? FIXME - Ajax?
 * http://stackoverflow.com/questions/13425815/how-to-use-requirejs-with-zepto
 * http://simonsmith.io/using-zepto-and-jquery-with-requirejs/
 *
 */
require(['cs!app/csmain']);
