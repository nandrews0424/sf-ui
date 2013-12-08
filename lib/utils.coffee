q = require 'q'
_ = require 'lodash'
_.str = require 'underscore.string'
log = require './log'

exports.cast = cast = (val, cb) -> 
  if _.isArray val
    return _.map val, (v) -> cast v, cb
  else if _.isObject val      
    return _.reduce(val, (obj, v, k) ->
      obj[k] = cast v, cb
      obj
    , cb(val)) || null
  else    
    return cb(val)    

exports.extractSubdocs = extractSubdocs = (doc) ->  
  _.reduce doc, (obj, v, k) ->    
    [k, sub] = k.split /__/
    if k && sub       
      obj[k] ||= {} 
      obj[k][sub] = v
      delete obj["#{k}__#{sub}"]
    obj
  , doc

exports.camelize = (row) ->
  _.reduce(row, (acc, v, k) ->    
    key = _.str.camelize(k.toLowerCase())
    acc[key] = v;
    acc
  , {})  

exports.camelizeAll = (obj) ->
  if _.isPlainObject(obj)
    exports.camelize(obj)
  else if _.isArray(obj)
    return _.each obj, (row, i, k) -> obj[i] = exports.camelizeAll(row)    
  else
    return obj


exports.pipeline = (input, definition) ->

  r = _.reduce definition, (acc, fn, key) ->
    
    acc
      .then (ctx) -> 
        try
          val = fn(ctx)
        catch e
          throw e

        q.when(val).fail (e) ->
          throw e

      .fail (e) ->        
        throw e

  , q(input)

  r  


exports.escapeNewlines = (p) ->
  if _.isObject p
    _.each p, (v,k) -> p[k] = escapeNewlines(v)
    p
  else if _.isString p
    p.replace("\n", "\\n")
  else if _.isArray p
    _.map p, (v) -> escapeNewlines(v)
  else
    p
