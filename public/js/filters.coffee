angular.module("app.filters")
	.filter 'join', ->
		(str,sep) -> str.join sep

	.filter 'unix', () ->
		(val, format="MMMM Do YYYY, h:mm:ss a") ->			
			moment.unix(val).format(format)

	.filter("fromNow", () -> 
		(date) ->			
			moment(date).fromNow()
	)
	.filter('moment', ()->
		(date, format="MMMM Do YYYY, h:mm:ss a") ->
			return "" unless date
			moment(date).format(format)
	)
	.filter('convertNewlines', () ->
		(text) ->			
			text.replace(/\n/g, '<br>') if text
	)
	.filter('phoneFormat', ->
		
		(text) ->
			text
	)
	.filter('jobDateFormatter', ->
		(job) ->
			left = ""
			if job.startMonth
				left+="#{job.startMonth}/"

			left+=job.startYear

			right = ""
			if job.endMonth 
				right+="#{job.endMonth}/"

			if !job.endYear || job.endYear == 5000
				right+="Present"
			else 
				right+=job.endYear

			"#{left} - #{right}"
	)


_.each(_.functions(_),(fn) ->
	angular.module('app.filters').filter("_#{fn}", () -> _[fn])
)

_.each(_.functions(_.str), (fn) ->	
	angular.module('app.filters').filter("_str#{_.str.capitalize(fn)}", _.memoize -> _.str[fn])
)	

