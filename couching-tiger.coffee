path = require 'path'
fs = require 'fs'
util = require 'util'
couchapp = require 'couchapp'

class CouchingTiger
  constructor: (name) ->
    @ddoc =
      _id: "_design/#{name}"
      rewrites:
        [
          {from: '/api', to: '../../'}
          {from: '/api/*', to: '../../*'}
        ]
      modules: {}
      views: {}
      lists: {}
      shows: {}

  views: (views) -> @ddoc.views[k] = v for own k, v of views
  shows: (shows) -> @ddoc.shows[k] = v for own k, v of shows
  lists: (lists) -> @ddoc.lists[k] = v for own k, v of lists
  rewrites: (rewrites...) -> @ddoc.rewrites.push r for r in rewrites

  # Doesn't handle dependencies yet... might be tricky - something in package.json maybe?
  requires: (modules...) ->
    @ddoc.modules[module] = fs.readFileSync (require.resolve module), 'utf8' for module in modules

  # Should just pull this code out of couchapp
  public: (dir) ->
    couchapp.loadAttachments @ddoc, path.join __dirname, 'public'

  loadDir: (step, obj = @ddoc, basePath = __dirname) ->
    fpath = path.join basePath, step
    obj = (obj[step] or obj[step] = {})

    for name in fs.readdirSync fpath when name[0] isnt '.'
      file = path.join fpath, name
      stat = fs.statSync file
      if stat.isFile()
        obj[name.replace /\.[^\.]*/, ''] = fs.readFileSync file, 'utf8'
      else if stat.isDirectory()
        loadDir name, obj, fpath

module.exports = CouchingTiger
