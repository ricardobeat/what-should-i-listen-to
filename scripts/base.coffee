makeNoise = (opacity = 0.2) ->

	return false if !document.createElement('canvas').getContext

	if window.localStorage? and window.localStorage["noise-#{opacity}"]
		noise = window.localStorage["noise-#{opacity}"]
		
	else
		canvas = document.createElement 'canvas'
		ctx = canvas.getContext '2d'
	
		canvas.width  = 45
		canvas.height = 45
	
		for x in [0...canvas.width]
			for y in [0...canvas.height]
				n = Math.round (Math.random()*60)
				ctx.fillStyle = "rgba(#{[n,n,n,opacity].join(',')})"
				ctx.fillRect x,y,1,1
	
		noise = canvas.toDataURL('image/png')
		
		if window.localStorage?
			window.localStorage["noise-#{opacity}"] = noise
	
	document.getElementsByTagName('html')[0].style.backgroundImage = "url(#{noise})"

makeNoise .2

jQuery ($) ->

	# button
	button = $ '#recommend'

	# random phrase
	phrases = ["I need to know.", "I have no idea.", "Hmmmmm...", "How about..."]
	phrase = phrases[~~(Math.random()*phrases.length)]

	button.text phrase
	
	# recommendation
	button.click ->
		user = $('#username').val()
		$.get "/recommendation/#{user}", (response) ->
			console.log response
