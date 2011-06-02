
express = require 'express'
request = require 'request'
qs      = require 'querystring'

api_key = require('/apiKey.js')

default = 'The Beatles (sorry, something went wrong here)'

app = express.createServer()

app.configure ->
	app.use express.cookieParser()
	app.use express.session
		secret: 'nothingspecial'
	app.use express.compiler
		src: "#{__dirname}/public"
		enable: ['less', 'coffeescript']
	app.use express.static "#{__dirname}/public"
	app.use express.errorHandler()

app.get '/recommend/:user', (req, res) ->
	
	limit = req.session.totalPages or 999
	page  = Math.floor(Math.random()*limit)
	
	params = 
		method  : 'library.getartists'
		api_key : api_key
		user    : req.params.user
		page    : page
		limit   : 1
		format  : 'json'
		
	request.get { uri: "http://ws.audioscrobbler.com/2.0/?#{qs.stringify params}" }, (err, response, body) ->
		try
			result = JSON.parse body
			if result?.artists?
				req.session.totalPages = result.artists['@attr']?.totalPages
				res.end result.artists.artist?.name
			else
				res.end default
		catch e
			res.end default
		
app.listen 10317