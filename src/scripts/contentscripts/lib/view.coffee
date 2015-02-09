root = config.socializer_url()

view =
  root: root

  loginPrompt: (callback) ->
    $('div.editor-taglist-wrapper').after(
      """
        <div class="row socializer-login-prompt" style="border-top: rgba(0,0,0,0.3) 1px dashed; border-bottom: rgba(0,0,0,0.3) 1px dashed; margin-top: 10px; padding-top: 10px;">
          <div class="columns medium-12 small-12">
            <h4>In order to draft Twitter/Facebook posts, <a id="socializer-login" href="#">log into Gawker Socializer</a> with your work email</h4>
          </div>
        </div>

      """
    )
    $('#socializer-login').on 'click', =>
      chrome.runtime.sendMessage method: 'login'

  addFields: (canEdit, callback) ->
    console.log 'add fields now'
    $('input.js_taglist-input').attr('tabindex', 3)
    # $('[TabIndex*="5"]').attr('tabindex', -1)
    iconStyle = 'style="margin: .5rem 0; opacity: 0.5; display: inline-block !important;"'
    textareaStyle = 'class="ap_social_textarea js_taglist-input taglist-input mbn inline-block no-shadow" style="width: 568px; color: #000; border: none; margin-top: 10px;"'
    # $('div.row.editor-actions').after(
    message = ""
    if canEdit
      content =
        """
        <div style="position: relative;">
          #{message}
          <div class="row collapse ap_social_row" style="border-top: rgba(0,0,0,0.3) 1px dashed; border-bottom: rgba(0,0,0,0.3) 1px dashed; margin-top: 10px; padding-top: 10px;">
            <div class="column">
              <span class="js_tag tag">
                <i class="icon icon-twitter" #{iconStyle}></i>
                <div class="js_taglist taglist">
                  <span class="js_taglist-tags taglist-tags mbn no-shadow"></span>
                  <textarea id="tweet-box" #{textareaStyle} type="text" name="tweet" placeholder="Tweet your words" value="" tabindex="4"></textarea>
                  <span class="tweet-char-counter" style="position: absolute; right: 30px; bottom: 20px; color: #999999;"></span>
                </div>
              </span>
            </div>
          </div>


          <div class="row collapse ap_social_row" style="margin-top: 10px; padding-top: 10px;">
            <div class="column">
              <span class="js_tag tag">
                <i class="icon icon-facebook" #{iconStyle}></i>
                <div class="js_taglist taglist">
                  <textarea id="ap_facebook-box" #{textareaStyle} type="text" name="tweet" placeholder="Facebook your feelings" value="" tabindex="4"></textarea>
                </div>
              </span>
            </div>
          </div>
        </div>
        """
    else
      content = '<h5 style="text-align: center; color: #999;">Save your first draft to edit social posts</h5>'
    $('div.editor-taglist-wrapper').after(content)
    $('.ap_social_row').on 'click', (el) ->
      $(el.currentTarget).find('textarea').focus()
    $('#tweet-box').on 'keyup', =>
      @setCharCount()
    setTimeout =>
      @setCharCount()
    , 500
    callback()

  setCharCount: ->
    charCount = Socializer.countdown()
    if charCount < 0 then cssTweak = color: 'red' else cssTweak = {color: '#999'}
    # debugger
    $('.tweet-char-counter').text(charCount).css(cssTweak)

  removeFields: ->
    console.log 'remove fields now'