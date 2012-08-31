jQuery.download = (url, data, method) ->
  #url and data options required
  if url and data
    #data can be string of parameters or array/object
    data = (if typeof data is "string" then data else jQuery.param(data))
    #split params into form inputs
    inputs = ""
    jQuery.each data.split("&"), ->
      pair = @split("=")
      inputs += "<input type=\"hidden\" name=\"" + pair[0] + "\" value=\"" + pair[1] + "\" />"
    #send request
    jQuery("<form action=\"" + url + "\" method=\"" + (method or "post") + "\">" + inputs + "</form>").appendTo("body").submit().remove()

$ ->

  $("#src").bind "textchange", ->
    $.ajax '/download',
      type: 'GET'
      data: {cheats: $("#src").val(), check: 1}
      dataType: 'json'
      success: (data, textStatus, jqXHR) ->
        console.log data
        if data.error
          $('body').append "format error"
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "communication error."

  $("#src").autoResize
    maxHeight: 10000
    animateDuration: 300
    animateCallback: ->
      $(this).css opacity: 1

  $("#download_btn").click (e) ->
    console.log "download start."
    $.download "/download", \
      {filename: $("#filename").val() , cheats: $("#src").val()}, \
      'get'

