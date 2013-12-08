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



# todo: for testing, remove when further along w/ content.....
window.lorem = (min=25,max=125) ->
	text = [
		"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium",
		"Totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta",
		"Sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia",
		"Consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui",
		"Dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora"
	]
	
	t = _.sample(text)
	while t.length < max
		t += _.sample(text)

	if t.length > max
		t = t.substring(0,_.random(min,max))

	t