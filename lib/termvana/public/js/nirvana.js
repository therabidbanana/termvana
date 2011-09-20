(function($) {
  if (!window.WebSocket && !window.MozWebSocket) { 
    alert("This browser does NOT support websockets and thus termvana fail :("); 
  }
  if(window.WebSocket) var ws = new WebSocket("ws://"+window.location.host+"/socket");
  else if(window.MozWebSocket) var ws = new MozWebSocket("ws://"+window.location.host+"/socket");
  ws.onopen = function(e){
    ws.send(JSON.stringify({full_command: "load_environment"}));
  }
  ws.onmessage = function(e) {
    var data = e.data;
    data = JSON.parse(data);
    if (data.type == ("AUTOCOMPLETE")) {
      var completions = $.parseJSON(data.replace(/^:AUTOCOMPLETE: /, ''));
      $.readline.finishCompletion(completions);
    } else {

      if(data.type == "system"){
        if(data['data'] && data['data']['environment'])
          $('#current_working_dir').text(data.data.environment.cwd);
      }
      else{
        $.repl.logResult(data.message);
      }
    }
  };
  ws.onclose = function() {
    $.repl.disable();
    return $.repl.log("<div class='nirvana_exception'>termvana: websocket closed</div>");

  };
  ws.onerror = function() {
    return $.repl.log("<div class='nirvana_exception'>termvana: websocket error</div>");
  };

  $.ws = function() { return ws };
  $.ws.nirvanaComplete = function(val) { console.log("No auto complete yet") };
})(jQuery);