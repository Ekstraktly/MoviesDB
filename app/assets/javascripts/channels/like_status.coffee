App.like_status = App.cable.subscriptions.create "LikeStatusChannel",
  connected: ->
    App.like_status.appear()
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $(document).ready ->
      like_statuses_html = ( '<p>' +
                             like_status +
                             '</p>' for like_status in data['like_statuses'] )
      document.getElementById('like_statuses').innerHTML = like_statuses_html.join('')
    # Called when there's incoming data on the websocket for this channel

  appear: ->
    @perform('appear')

  speak: ->
    @perform 'speak'