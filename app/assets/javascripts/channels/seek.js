App.seek = App.cable.subscriptions.create({ channel: "SeekChannel"}, {
connected: function() {},
disconnected: function() {},
received: function (data) {
  console.log(data)
},
});