// rn-cli.config.js
const extraNodeModules = require('node-libs-browser');

module.exports = {
  extraNodeModules
}

// Inject node globals into React Native global scope.
global.Buffer = require('buffer').Buffer;
global.process = require('process');
