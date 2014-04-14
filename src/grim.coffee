console.log "OK OK"
_ = require 'underscore-plus'

global.__grimlog__ = {}

grim =
  getLog: ->
    global.__grimlog__

  clearLog: ->
    global.__grimlog__ = {}

  logDeprecationWarnings: ->
    warnings = []
    warnings.push [method, metadata] for method, metadata of grim.getLog()
    warnings.sort (a, b) -> b[1].count - a[1].count

    console.warn "\nCalls to deprecated functions\n-----------------------------"
    for [method, metadata] in warnings
      console.warn "(#{metadata.count}) #{method} : #{metadata.message}", metadata

  deprecate: (message) ->
    try
      throw new Error("Deprecated Method")
    catch e
      stackLines = e.stack.split("\n")
      [all, method] = stackLines[2].match(/^\s*at\s*(\S+)/)

    console.log "THIS"
    console.log grim
    grim.getLog()[method] ?= {message: message, count: 0, stackTraces: []}
    grim.getLog()[method].count++
    grim.getLog()[method].stackTraces.push e.stack

module.exports = grim