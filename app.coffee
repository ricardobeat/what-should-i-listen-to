
express = require 'express'
request = require 'request'
qs      = require 'querystring'

api_key = require('./apiKey')

app = express.createServer()

app.configure ->
	app.use express.cookieParser()
	app.use express.session
		secret: 'nothingspecial'
	
	#app.use express.compiler
	#	src: __dirname + "/public"
	#	enable: ["less","coffeescript"]
		
	app.use express.static "#{__dirname}/public"
	#app.use express.errorHandler()

app.get '/recommend/:user', (req, res) ->

	res.header 'Content-Type', 'text/plain'
	
	limit = req.session.totalPages or 999
	page  = Math.floor(Math.random()*limit)
	
	params = 
		method  : 'library.getartists'
		api_key : api_key
		user    : req.params.user
		page    : page
		limit   : 1
		format  : 'json'
		
	request { uri: "http://ws.audioscrobbler.com/2.0/?#{qs.stringify params}"}, (err, response, body) ->
		try
			body = JSON.parse body
		catch e
			return res.end ""
		
		if body?.artists and not (body.artists.totalPages == '0')
			req.session.totalPages = body.artists['@attr'].totalPages or 900
			res.end body.artists.artist.name or ""
		else
			res.end ""
		
app.listen 10320
console.log "server running on port 10320"
