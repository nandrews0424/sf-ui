require('../../bower_components/jquery/jquery.min.js')
require('../../bower_components/bootstrap/dist/js/bootstrap.js')
require('../../bower_components/angular/angular.min.js')

moment = require('../../bower_components/moment/min/moment.min.js')
_ = require('../../bower_components/lodash/dist/lodash.min.js')
_.str = require('../../bower_components/underscore.string/dist/underscore.string.min.js')
mustache = require('../../bower_components/mustache/mustache.js')

require('../../bower_components/jquery.expanding-textareas/expanding.js')
require('../../bower_components/angular-sanitize/angular-sanitize.min.js')
require('../../bower_components/angular-route/angular-route.min.js')
require('../../bower_components/angular-bootstrap/ui-bootstrap-tpls.min.js')
require('../../bower_components/bootstrap-wysihtml5/src/bootstrap-wysihtml5.js')

_.mixin({
	'chunk': function(array, n) {
	    if (!_.isNumber(n) || n < 1 || !_.isArray(array)) return array;
	        var i = 0, l = array.length, r = [], j = Math.ceil(l/n);
	        while (i < j) {
	            r[i] = array.slice(i*n, n*(i+1));
	            i++;
	        }
	    return r;
	},
	camelize: function(row) {
		return _.reduce(row, function(acc, v, k) {
			var key;
			key = _.str.camelize(k.toLowerCase());
			acc[key] = v;
			return acc;
		}, {});
	},
	camelizeAll: function(obj) {
		if (_.isPlainObject(obj)) {
			return _.camelize(obj);
		} else if (_.isArray(obj)) {
			return _.each(obj, function(row, i, k) {
				return obj[i] = _.camelizeAll(row);
			});
		} else {
			return obj;
		}
	}	
})