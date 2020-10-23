
document.addEventListener('DOMContentLoaded', function () {
    console.log('loaded')
  
    const input = document.getElementById('chat-input')
    const button = document.getElementById('button')
    button.addEventListener('click', function () {
        const content = input.value
        const data = {
            room_id: 1,
            message: content,
        }
        App.room.speak(data)
        input.value = ''
    })
})