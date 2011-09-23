var App = {
  Views: {},
  Models: {},
  CommandHistory: {},
  init: function(){
    // Backbone.history.start({pushState: true, silent: true});
  }
}


jQuery(function($){
  App.init();
  new App.Views.Command();
});


