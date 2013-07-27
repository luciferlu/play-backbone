require("jquery")
bb = require("backbone")
d = require("dustjs-linkedin")
require("dustjs-linkedin-helpers")
Q = require('q')

backbone_sync = bb.sync
bb.sync = (method, model, options) ->
    Q.when backbone_sync(method, model, options)

class Collection extends bb.Collection
    fetch: (options...) ->
        super(options...).then =>
            this

class View extends bb.View
    q: Q

    renderDust: (name, context) ->
        deferred = Q.defer()
        d.render name, context,
            (err, out) =>
                if err?
                    deferred.reject err
                else
                    deferred.resolve(out)
        deferred.promise

    release: ->
        stopListening()

class Model extends bb.Model

class Router extends bb.Router

Backbone =
    Collection: Collection
    View: View
    Model: Model
    Router: Router
    history: bb.history

module.exports.Backbone = Backbone