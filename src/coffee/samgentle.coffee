drawing = false;

stopDrawing = -> drawing = false; return
startDrawing = (evt) ->
  evt.preventDefault()
  drawing = true
  draw evt

draw = (evt) ->
  if drawing
    evt.preventDefault()

    ctx = evt.target.getContext '2d'
    offset = $(evt.target).offset()

    touches = [evt] if !touches = evt.originalEvent.touches
    points = ({x: touch.pageX - offset.left, y: touch.pageY - offset.top} for touch in touches)

    circle ctx, x, y, 'RGBA(255,255,255,1)' for {x, y} in points

    window.setTimeout ->
      ctx.globalCompositeOperation = 'copy'
      circle ctx, x, y, 'RGBA(255,255,255,0)' for {x, y} in points
      ctx.globalCompositeOperation = 'source-over'
    , 2000

circle = (ctx, x, y, colour) ->
  ctx.save()
  ctx.beginPath()
  ctx.arc x, y, 15, 0, Math.PI*2, true
  ctx.closePath()
  ctx.clip()
  ctx.fillStyle = colour;
  ctx.fill()
  ctx.restore()

$(document).ready ->
  canvas = $('#dnecanvas')
  canvas.on "mousedown touchstart", startDrawing
  canvas.on "mousemove touchmove", draw
  $(document).on "mouseup touchend", stopDrawing

  locale = navigator.languages?[0]

  $('time').each (i, el) ->
    $(el).text new Date($(el).attr('datetime')).toLocaleString(locale)