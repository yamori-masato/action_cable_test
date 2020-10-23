const user = {}
const room = {}

App.seek = App.cable.subscriptions.create({ channel: "SeekChannel" }, {
  connected: function() {},
  disconnected: function() {},
  received: function (data) {
    // 接続されたタイミングでサーバからdataを受け取る ex) data = { action: "battle_start", room_id: "#{room.id}" }
    console.log(`seek:received => ${data}`)
    room.id = data.room_id
  },
  connect: function () {
    console.log("waiting...")
    return this.perform('connect');
  }
});
