#= require './app'
App.Models.Command = Backbone.Model.extend
  initialize: ->
    this
  sendable: ->
    JSON.stringify({full_command: this.get('input'), cid: this.cid})

