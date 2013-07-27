Backbone = require('me.ezcode').Backbone
require("jquery")
User = require('./models/user.coffee')
UserEditor = require('./views/user-editor.coffee')

class App extends Backbone.Router
    routes:
        "":         "home"
        "start":    "startApp"

    home: ->

    startApp: ->
        user = new User
            id: "0001"
        userEditor = new UserEditor
            user: user
        user.fetch()
        $("#app-container").html(userEditor.el)

$ ->
    app = new App()
    Backbone.history.stop()
    Backbone.history.start()