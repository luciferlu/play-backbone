Backbone = require('me.ezcode').Backbone
require("templates")

class UserEditor extends Backbone.View
    events:
        "click #btnOk":     "save"

    initialize: (options) ->
        @user = options.user
        @listenTo(@user, "sync", @render)

    render: ->
        @renderDust('user-edit-view', @user.toJSON())
        .then (html) =>
            @$el.html html

        return @

    save: ->
        @user.set
            name: @$("#name").val()
        @user.save()
        .then =>
            @$(".info").html("Saved").show()

module.exports = UserEditor