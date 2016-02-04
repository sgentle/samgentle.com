CouchingTiger = require './couching-tiger'

app = new CouchingTiger('app')

app.public 'public'
app.requires 'mustache'
app.loadDir 'templates'

app.rewrites from: '/', to: '/_list/tmpl/bytype', query: {type: 'home', descending: 'true', limit: '5', endkey: ['posts'], startkey: ['posts', {}]}
app.rewrites from: '/feed', to: '/_list/tmpl/bytype', query: {type: 'feed', format: 'xml', descending: 'true', limit: '20', endkey: ['posts'], startkey: ['posts', {}]}
app.rewrites from: '/rss', to: '/_list/tmpl/bytype', query: {type: 'rss', format: 'xml', descending: 'true', limit: '20', endkey: ['posts'], startkey: ['posts', {}]}
app.rewrites from: '/sitemap', to: '/_list/tmpl/bytype', query: {type: 'sitemap', format: 'xml', descending: 'true', endkey: ['posts'], startkey: ['posts', {}]}
app.rewrites from: '/projects', to: '/_list/tmpl/bytype', query: {type: 'projects', descending: 'true'}
app.rewrites from: 'irishcripwalk.html', to: 'irishcripwalk.html'
app.rewrites from: 'keybase.txt', to: 'keybase.txt'
app.rewrites from: 'favicon.ico', to: 'favicon.ico'
app.rewrites from: '/youtubemashup', to: '/_list/tmpl/bytype', query: {type: 'interwebmashup'}

app.rewrites from: '/:type', to: '/_list/tmpl/bytype', query: {type: ':type', startkey: [':type'], endkey: [':type', {}]}
app.rewrites from: '/static/*', to: '*'
app.rewrites from: '/:type/:id', to: '/_show/tmpl/:type/:id'

app.views
  bytype:
    map: (doc) ->
      type = doc._id.split('/')[0]
      now = new Date().toISOString()
      emit [type, doc.created], doc if type? and !doc.created or doc.created <= now

app.lists
  tmpl: (head, req) ->
    data = {_nav: {}}
    data._query = q = req.query
    data._nav.next = Number(q.skip || 0) + Number(q.limit)
    data._nav.prev = if Number(q.skip) >= Number(q.limit) then Number((q.skip || 0)) - Number(q.limit)
    data._nav.prev += '' if data._nav.prev?
    if (vhostpath = req.headers['x-couchdb-vhost-path'])
      data._canonical = 'https://samgentle.com' + vhostpath

    by_year = {}
    if @templates[req.query.type]
      mustache = require 'modules/mustache'
      provides (req.query.format or 'html'), ->
        count = 0
        while row = getRow() when !row.value.hidden
          count++
          key = row.key[0]
          val = {}
          val[k] = v for k, v of row.value
          data[key] ||= []
          data[key].push val

          val._created_friendly = new Date(val.created).toUTCString() if val.created

          if year = row.value.year
            if !this_year = by_year[year]
              this_year = by_year[year] = {year}
              this_year[key] = []
            this_year[key].push row.value

          data._latest = row.value.created if !data._latest

        data._by_year = (v for k, v of by_year)

        delete data._nav.next if q.limit && count < Number(q.limit)

        data._latest_friendly = new Date(data._latest).toUTCString() if data._latest

        mustache.to_html @templates[req.query.type], data, @templates
    else
      throw ['error', 'not_found', "no such template '#{req.query.type}'"]

app.shows
  tmpl: (doc, req) ->
    if @templates[doc.type]
      doc._future = doc.created > new Date().toISOString()
      if (vhostpath = req.headers['x-couchdb-vhost-path'])
        doc._canonical = 'https://samgentle.com' + vhostpath

      mustache = require 'modules/mustache'
      mustache.to_html @templates[doc.type], doc, @templates
    else
      # Better error reporting with HTTP codes?
      JSON.stringify {error: 'query_error', reason: "no such template #{doc.type}"}

app.ddoc.validate_doc_update = (newDoc, oldDoc, userCtx) ->
  if (userCtx.roles.indexOf('_admin') == -1)
    throw unauthorized: 'Only admin can modify documents on this database.'

module.exports = app.ddoc
