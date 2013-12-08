angular.module('app.services').service('$audio', [ '$q', '$http', ($q, $http) -> 

	context = new webkitAudioContext()
	buffered = {}

	@load = (resourcePath) ->
		d = $q.defer()

		if buffered[resourcePath]
			d.resolve buffered[resourcePath]
			return d.promise

		$http.get(resourcePath, { responseType: 'arraybuffer' })
			.then (r) ->
				context.decodeAudioData r.data, (audio) ->
					return d.reject "Error decoding audio data '#{resourcePath}'" unless audio
					d.resolve buffered[resourcePath] = audio
			.catch (r) -> 
				d.reject r

		d.promise

	@play = (resourcePath) ->
		 @load(resourcePath).then (buffer) ->

		 	console.log "buffer returned", buffer 
		 	source = context.createBufferSource()
		 	source.buffer = buffer
		 	source.connect context.destination
		 	source.noteOn 0
])
