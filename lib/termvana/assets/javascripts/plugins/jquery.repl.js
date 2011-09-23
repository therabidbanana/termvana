(function($) {
  var screen, input, resultPrompt, prompt_id;

  // Options:
  // * prompt: html string to use as prompt
  // * resultPrompt: html string before each result
  // * loop: function to handle eval and logging of its result,
  //     default is $.repl.loop
  // * startMessage: function which returns string to display when starting repl
  $.fn.repl = function(options) {
    options = $.extend({
      prompt: '&gt;&gt; ',
      resultPrompt: '=> ',
      loop: $.repl.loop,
      startMessage:  function() {
        return '# New repl.js session using jQuery '+$().jquery;
      }
    }, options);

    input = $(this);
    input.addClass('repl_input');
    resultPrompt = options.resultPrompt;
    var input_id = this.selector.replace(/^#/, '');

    prompt_id = input_id + '_prompt';
    if (!$('#'+prompt_id).length) {
      input.before('<span id="'+prompt_id+'"></span>');
    }
    var screen_id = input_id + '_screen';
    $('#'+prompt_id).html(options.prompt).
      before("<div id='"+ screen_id +"'></div>");
    screen = $('#'+screen_id);

    if (options.startMessage) { $.repl.log(options.startMessage()); }
    input.focus();
    input.parent('form').submit(function() {
      var line = input.val();
      $.repl.log(options.prompt + line );
      options.loop(line);
      input.val("").focus();
      return false;
    });
    if ($.hotkeys) {
      input.bind('keydown', 'ctrl+l', function() { screen.html(''); });
    }

    return this;
  };

  $.repl = {
    version: '0.2.0',
    log: function(str) {
      screen.append(str + "<br>");
      return $('body').scrollTop($('body').attr('scrollHeight'));
    },
    logResult: function(str) {
      var node = $("<div class='command'>");
      node.append($("<code>"))
      $("code", node).append($("<pre>").text(str));
      screen.append(node);

      return $('.termkitCommandView').scrollTo($('#input'));
    },
    disable: function() {
      $('#'+prompt_id).hide();
      return input.hide();
    },
    enable: function() {
      $('#'+prompt_id).show();
      return input.show();
    },
    eval: function(input) {
      try { var result = eval(input); }
      catch(e) { var result = e.name + ': '+ e.message; }
      if (typeof(result) == 'undefined') {
        result = 'undefined';
      } else {
        result = result ? result.toString() : '';
        result = $('<div/>').text(result).html();
      }
      return result;
    },
    loop: function(line) {
      var result = $.repl.eval(line);
      return $.repl.logResult(result);
    }
  };
})(jQuery);
