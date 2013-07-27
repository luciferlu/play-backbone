Backbone = require('me.ezcode').Backbone

class User extends Backbone.Model
    urlRoot: "/service/users",

    initialize: ->
        @bind "change:name", ->
            console.log("name is changing")

    defaults:
        name: "tanxianhu"
        age: "5"

module.exports = User