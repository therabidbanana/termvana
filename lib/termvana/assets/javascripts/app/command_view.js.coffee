#= require './app'
App.Views.Command = Backbone.View.extend
  events:
    "click": "log"
    "submit form": "runCommand"
  initialize: ->
    self = this
    this.model = new App.Models.Command()
    App.CommandHistory[this.model.cid] = this.model

    this.model.bind("change", this.rerender, this)
    this.render()
    this
  log: ->
  runCommand: (e)->
    this.model.set({input: $('input.prompt-input', this.el).val()})
    console.log(this.model.sendable())
    $.ws().send(this.model.sendable())
    if $(this.el).hasClass('first-run')
      $(this.el).removeClass('first-run')
      new App.Views.Command
    e.preventDefault()
    false

  render: ->
    this.rerender()
    $(this.el).addClass('first-run')
    $('.termkitCommandView').append(this.el)
    $('input', this.el).focus()
    return this
  rerender: ->
    $(this.el).html JST['templates/command']({command: this.model})
    if($('input:focus').length != 0)
      $('.termkitCommandView').scrollTo($('input:focus'))
    return this

