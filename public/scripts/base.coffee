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
	recommend    = $ '#recommend'
	artist       = $ '#artist'
	username     = $ '#username'
	errorMessage = $ '#errorMessage'
	
	if window.localStorage and localStorage.username
		username.val localStorage.username

	# random phrase
	phrases = ["I need to know.", "I have no idea.", "Hmmmmm...", "How about..."]
	phrase = phrases[~~(Math.random()*phrases.length)]

	recommend.text phrase
	
	showRecommendation = (result) ->
		if not result then errorMessage.show() else errorMessage.hide()
		artist.html "<a href=\"http://grooveshark.com/#/search?q=#{escape result}\">result</a>" or 'The Beatles'
		recommend.text 'Try again'
		recommend.addClass 'used'
	
	# recommendation
	recommend.click (e) ->
		e.preventDefault()
		user = username.val()
		user and window.localStorage and localStorage.username = user
		user or= 'superbife'
		$.ajax
			url: "/recommend/#{user}"
			success: showRecommendation
			error: showRecommendation
			type: 'GET'
			dataType: 'text'
		_gaq? and _gaq.push ['_trackEvent', 'What should I listen to?', 'Recommendation', user]
		
	recommend.next('form').submit (e) ->
	    e.preventDefault()
	    recommend.click()
	
