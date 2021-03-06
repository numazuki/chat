document.addEventListener('turbolinks:load', function() {
  window.messageContainer = document.getElementById('message-container')
  if (messageContainer === null) {
      return
  }  
  if (App.room) {
    App.cable.subscriptions.remove(App.room);
  }
  App.room = App.cable.subscriptions.create({
    channel: "RoomChannel",
    room: $('#message-container').data('room_id')
  }, {
    connected: function() {
      console.log('connect');
      scrollToBottom();

    },
    disconnected: function() {},
    received: function(data) {
      console.log('receive');
      messageContainer.insertAdjacentHTML('beforeend', data['message'])
      scrollToBottom();
    },
    speak: function(message) {
      this.perform('speak', {
        message: message
      });
    }
  });


  
  $('#chat-input').on('keypress', function(event) {
    if (event.keyCode === 13) {
      if (event.shiftKey) { // Shiftキーも押された
        $.noop();
      } else if(event.target.value != "") {
        App.room.speak(event.target.value);
        event.target.value = '';
        return event.preventDefault();        
      }           
    }
  });

  var documentElement = document.documentElement
    // js.erb 内でも使用できるように変数を決定
  window.messageContent = document.getElementById('message_content')

  window.scrollToBottom = () => {
    var a = document.documentElement;
    var y = a.scrollHeight - a.clientHeight;
    window.scroll(0, y);
  }
  
  scrollToBottom();

  // 最初にページ一番下へ移動させる
  
  $('#message-container').animate({scrollTop: $('#message-container')[0].scrollHeight}, 'fast');

  let oldestMessageId
  let room_id
  window.addEventListener('scroll', () => {
      window.showAdditionally = true
      if (documentElement.scrollTop === 0 && showAdditionally) {
          showAdditionally = false
          oldestMessageId = document.getElementsByClassName('message')[0].id.replace(/[^0-9]/g, '')
          room_id = document.getElementById('message-container').getAttribute('data-room_id')
          post_data = {
            room_id: room_id,
            oldest_message_id: oldestMessageId
          }
          // Ajax を利用してメッセージの追加読み込みリクエストを送る。最も古いメッセージidも送信しておく。
          $.ajax({
              type: 'GET',
              url: '/show_additionally',
              cache: false,
              data: {post_data: post_data,
                     remote: true}
          })
      }
  }, {passive: true});  
  
});