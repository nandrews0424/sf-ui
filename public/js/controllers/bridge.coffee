angular.module('app').controller('BridgeController', ['$scope', '$rootScope', '$audio', ($scope, $rootScope, $audio) ->
	
	# $audio.play '/media/vigil.mp3'

	$rootScope.$emit "page:load"
])