w = $('section').width()
h = 480
r = Raphael "holder", w, h

c = null
c2 = null
c3 = null
radius = Math.min(w/2, h)/2 - 10

setup = ->
  r.clear()
  c = r.circle w/4, h/2, radius
  c.attr 'stroke-width': 5
  c.node.style.cursor = 'move'
  c.glow offsetx: 2, offsety: 2, width: 5
  c2 = r.circle w/4-80, h/2, radius/4
  c2.attr fill: 'rgba(255, 0, 0, 0.5)', 'stroke-width':2
  #c2.glow width: 2
  c3 = r.circle w/4-40, h/2, radius/4
  c3.attr fill: 'rgba(0, 0, 255, 0.5)', 'stroke-width':2
  #c3.glow width: 2
  text()
  update()

text = ->
  x = w*3/4
  y = h/2
  text = r.set [
    r.text x, y, "P(A|B)"
    r.text x + 100, y, "P(A∩B)"
    r.text x + 100, y+24, "P(B)"
  ]
  text.attr 'font-size': 24, 'font-family': '"Josefin Sans",sans-serif'


update = ->
  a = $('#sliderA').val()
  b = $('#sliderB').val()
  ab = $('#sliderAB').val()

  ar = a * radius
  br = b * radius

  ax = w/4 - radius + ar
  c2.attr r: ar, cx: ax

  foo = Math.min(w/4 - radius, ax)

  bx = foo + Math.max(ar, br) + br - br * ab * 2
  c3.attr r: br, cx: bx

$('#sliderA,#sliderB,#sliderAB').change ->        
  update()
  
$('#order').bind 'change input', ->
  neworder = parseInt($('#order').val(), 10)
  if order != neworder
    order = neworder
    setup()

setup()

  