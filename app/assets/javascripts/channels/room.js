console.log('a')
document.addEventListener("turbolinks:load", function () {
  console.log('loaded')
  const room_data = document.querySelector("#messages")
  const room_id = room_data.getAttribute("data-room-id")
  const name = room_data.getAttribute("data-user-name")

  App.room = App.cable.subscriptions.create(
    { channel: "RoomChannel", room_id: room_id },
    {
      // channelがクラス, room_id(任意)がchannel＃subscribed内のparams[:room_id]で取得できる。よってここにはroom名を指定できるものが望ましい。
      // room_idはDOMの属性で特定するようにする例が多く、そうすれば部屋を選択したタイミングでの取得が可能になる。
      connected: function() {},
      disconnected: function() {},
      received: function (data) {
        const messages = document.getElementById('messages')
        const child = document.createElement("p")

        // 以下は部分更新(追加)。ajaxかerb使って、partial呼び出せればもう少し綺麗にかけそう
        if (name === data.sender.name) { 
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
    }
  )



  const input = document.getElementById('chat-input')
  const button = document.getElementById('button')
  button.addEventListener('click', function () {
      const content = input.value
      const data = {
          room_id: room_id,
          message: content,
      }
      App.room.speak(data)
      input.value = ''
  })
})