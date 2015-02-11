ContactInfo =
  info_added: false
  init: ->
    chrome.storage.sync.get
      contact_email: ''
      pgp_sig: ''
      pgp_public_key: ''
    , (items) =>
      @email = items.contact_email
      @pgp_sig = items.pgp_sig
      @pgp_public_key = items.pgp_public_key
    Dispatcher.on 'post_refresh', (post) =>
      unless post.permalink? or @info_added
        console.log 'should add something to the bottom of the post'
        editor_text = $('.editor-inner').text()
        if editor_text.length is 1 and editor_text.charCodeAt(0) is 8203
          $('.editor-inner').append(@info())

  info: ->
    unless @email is ''
      text = "<hr><p><em>Contact the author at <a href=\"mailto:#{@email}\">#{@email}</a>."
      unless @pgp_sig is ''
        text += "<br>PGP Signature: #{@pgp_sig}"
        text += "<br><a href=\"#{@pgp_public_key}\" target=\"_blank\">PGP Public Key</a>"

      text += "</em></p>"
