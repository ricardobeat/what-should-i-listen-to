
express = require 'express'
request = require 'request'
qs      = require 'querystring'

api_key = require('./apikey')

app = express.createServer()

app.configure ->
	app.use express.compiler
		src: "#{__dirname}/public"
		enable: ['less', 'coffeescript']
	app.use express.static "#{__dirname}/public"
	app.use express.errorHandler()

app.get '/recommend/:user', (req, res) ->
	params = 
		method  : 'library.getartists'
		api_key : api_key
		user    : req.params.user
		page    : Math.floor(Math.random()*1500)
		limit   : 1
		format  : 'json'
		
	request.get { uri: "http://ws.audioscrobbler.com/2.0/?#{qs.stringify params}" }, (err, response, body) ->
		result = JSON.parse body
		res.end(result.artists?.artist?.name)
		
app.listen 3000