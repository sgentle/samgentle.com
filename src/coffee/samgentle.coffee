drawing = false

stopDrawing = -> drawing = false; return
startDrawing = (ev) ->
  ev.preventDefault()
  drawing = true
  draw ev

draw = (ev) ->
  if drawing
    ev.preventDefault()

    ctx = ev.target.getContext '2d'
    left = ev.target.offsetLeft
    top = ev.target.offsetTop

    for touch in ev.touches or [ev]
      x = touch.offsetX
      y = touch.offsetY

      circle ctx, x, y, 'RGBA(255,255,255,1)'

      window.setTimeout ->
        ctx.globalCompositeOperation = 'copy'
        circle ctx, x, y, 'RGBA(255,255,255,0)'
        ctx.globalCompositeOperation = 'source-over'
      , 2000

circle = (ctx, x, y, colour) ->
  ctx.save()
  ctx.beginPath()
  ctx.arc x, y, 15, 0, Math.PI * 2, true
  ctx.closePath()
  ctx.clip()
  ctx.fillStyle = colour
  ctx.fill()
  ctx.restore()

$ = document.querySelector.bind(document)
$$ = document.querySelectorAll.bind(document)

canvas = $('#dnecanvas')
canvas.addEventListener 'mousedown', startDrawing
canvas.addEventListener 'touchstart', startDrawing
canvas.addEventListener 'mousemove', draw
canvas.addEventListener 'touchmove', draw
canvas.addEventListener 'mouseup', stopDrawing
canvas.addEventListener 'touchend', stopDrawing

locale = navigator.languages?[0]

for el in $$('time')
  el.textContent = new Date(el.getAttribute('datetime')).toLocaleDateString(locale, timeZone: 'UTC')
