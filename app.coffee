
express = require 'express'
request = require 'request'
qs      = require 'querystring'

app = express.createServer()

app.get '/recommend/:user', (req, res) ->
	params = 
		method  : 'library.getartists'
		api_key : 'bee1fcef168222380ab5cff83403199c'
		user    : req.params.user
		page    : Math.floor(Math.random()*1500)
		limit   : 1
		format  : 'json'
		
	request.get { uri: "http://ws.audioscrobbler.com/2.0/?#{qs.stringify params}" }, (err, response, body) ->
		result = JSON.parse body
		res.end(result.artists?.artist?.name)
		
app.listen 3000