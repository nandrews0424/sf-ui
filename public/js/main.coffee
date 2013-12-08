angular.module("app.directives",[])
angular.module("app.filters",[])
angular.module("app.services",[])

app = angular.module 'app', ['app.directives','app.filters','app.services','ngSanitize','ngRoute','ui.bootstrap'],
	($routeProvider,$tooltipProvider) ->
		$routeProvider
			.when '/', 
				templateUrl: '/templates/bridge.html',
				controller: 'BridgeController'

app.run ($rootScope, $timeout) ->
	$rootScope.config = window.config

	pageTimeout = null
	# todo: abstract out...
	$rootScope.$on "$routeChangeStart", (event, context) ->
		$rootScope.pageLoad = false
		$rootScope.pageError = false
		$rootScope.loadFadeComplete = false

		$timeout.cancel(pageTimeout) if pageTimeout
		pageTimeout = $timeout -> 
			$rootScope.pageError = true unless $rootScope.pageLoad
		, 8000

	$rootScope.$on "page:load", (event) ->
		$rootScope.pageLoad = true
		$timeout -> 
			$rootScope.loadFadeComplete = true
		, 500

	$rootScope.$on "page:error", (event) ->
		$rootScope.pageError = true


require "./filters.coffee"
require "./directives.coffee"
require "./controllers/bridge.coffee"
require "./services/audio.coffee"

app.run ($rootScope) ->
	angular.extend($rootScope,config)