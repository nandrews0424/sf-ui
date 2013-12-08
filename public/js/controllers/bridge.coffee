angular.module('app').controller('BridgeController', ['$scope', '$rootScope', '$audio', ($scope, $rootScope, $audio) ->
	
	# $audio.play '/media/vigil.mp3'
	$scope.notifications = []
	$scope.inventory = []

	for i in [0...10]
		$scope.inventory.push 
			description: lorem(25, 100)
			type: _.sample ['resource', 'tech', 'intel']
			amount: _.random 100, 1000

	for i in [0...3]
		$scope.notifications.push
			title: lorem(20,45)
			detail: lorem(120, 180)



	$rootScope.$emit "page:load"
])