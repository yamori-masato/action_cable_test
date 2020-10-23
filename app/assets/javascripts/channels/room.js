App.room = App.cable.subscriptions.create({ channel: "RoomChannel", room_id: 1 }, {
  // channelがクラス, room_id(任意)がchannel＃subscribed内のparams[:room_id]で取得できる。よってここにはroom名を指定できるものが望ましい。
  // room_idはDOMの属性で特定するようにする例が多く、そうすれば部屋を選択したタイミングでの取得が可能になる。
  connected: function() {},
  disconnected: function() {},
  received: function (data) {
    const messages = document.getElementById('messages')
    const child = document.createElement("p")
    var content;

    // 以下は、ajax→再レンダリングにリファクタ(部分更新で済むからこっちのが良い？)
    if (your_name === data.sender.name) { 
      child.classList.add('yours') 
      content = data.content
    } else {
      child.classList.add('others') 
      content = `${data.sender.name}: ${data.content}`
    }
    child.innerHTML = content
    messages.appendChild(child)
  },

  speak: function (data) {
    return this.perform('speak', data);
  }
});


