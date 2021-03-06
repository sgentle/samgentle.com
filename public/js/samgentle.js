// Generated by CoffeeScript 1.10.0
(function() {
  var circle, draw, drawing, startDrawing, stopDrawing;

  drawing = false;

  stopDrawing = function() {
    drawing = false;
  };

  startDrawing = function(evt) {
    evt.preventDefault();
    drawing = true;
    return draw(evt);
  };

  draw = function(evt) {
    var ctx, j, len, offset, points, ref, touch, touches, x, y;
    if (drawing) {
      evt.preventDefault();
      ctx = evt.target.getContext('2d');
      offset = $(evt.target).offset();
      if (!(touches = evt.originalEvent.touches)) {
        touches = [evt];
      }
      points = (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = touches.length; j < len; j++) {
          touch = touches[j];
          results.push({
            x: touch.pageX - offset.left,
            y: touch.pageY - offset.top
          });
        }
        return results;
      })();
      for (j = 0, len = points.length; j < len; j++) {
        ref = points[j], x = ref.x, y = ref.y;
        circle(ctx, x, y, 'RGBA(255,255,255,1)');
      }
      return window.setTimeout(function() {
        var k, len1, ref1;
        ctx.globalCompositeOperation = 'copy';
        for (k = 0, len1 = points.length; k < len1; k++) {
          ref1 = points[k], x = ref1.x, y = ref1.y;
          circle(ctx, x, y, 'RGBA(255,255,255,0)');
        }
        return ctx.globalCompositeOperation = 'source-over';
      }, 2000);
    }
  };

  circle = function(ctx, x, y, colour) {
    ctx.save();
    ctx.beginPath();
    ctx.arc(x, y, 15, 0, Math.PI * 2, true);
    ctx.closePath();
    ctx.clip();
    ctx.fillStyle = colour;
    ctx.fill();
    return ctx.restore();
  };

  $(document).ready(function() {
    var canvas, locale, ref;
    canvas = $('#dnecanvas');
    canvas.on('mousedown touchstart', startDrawing);
    canvas.on('mousemove touchmove', draw);
    $(document).on('mouseup touchend', stopDrawing);
    locale = (ref = navigator.languages) != null ? ref[0] : void 0;
    return $('time').each(function(i, el) {
      return $(el).text(new Date($(el).attr('datetime')).toLocaleString(locale));
    });
  });

}).call(this);
