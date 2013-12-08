os = require 'os'
express = require 'express'
http = require 'http'
path = require 'path'
fs = require 'fs'
_ = require 'lodash'
less = require 'less-middleware'
coffeeify = require 'caching-coffeeify'
deglobalify = require 'deglobalify'
browserify = require 'browserify-middleware'

app = express()

app.set('root', process.cwd())
app.set('compiled_less', path.join(os.tmpDir(), "/scifi-ui-less-compiled"))

fs.mkdirSync app.get('compiled_less') unless fs.existsSync(app.get('compiled_less'))

app.configure 'development', ->
  app.set('port', 3000)   
  
  app.locals
    useAnalytics: false    
    adminUsers: []

  app.use less
    src: path.join app.get('root'),'public','less'
    dest: app.get('compiled_less')
    compress:false  
    debug:true
    prefix: 'less'
    paths: [
      path.join(app.get('root'),'public','less'),
      path.join(app.get('root'),'bower_components')
    ]


app.configure 'production', ->
  
  app.set('port', process.argv[2])   
  browserify.settings.production('minify', false)

  app.use less 
    src: path.join app.get('root'),'public','less'
    dest: app.get('compiled_less')
    compress:true
    paths: [
      path.join(app.get('root'),'public','less'),
      path.join(app.get('root'),'bower_components')
    ]

app.configure ->  
  app.enable('trust proxy')
  app.use(express.logger('default'))
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(express.cookieParser('cookies!'))
  
  app.engine('html', require('ejs').renderFile)
  
  app.use '/js', browserify('../public/js', { transform: [deglobalify,coffeeify] })
  app.use express.static(path.join(app.get('root'),'/public'))
  app.use express.static(app.get('compiled_less'))  
  app.use '/templates', express.static(path.join(app.get('root'), 'public','templates'))
  app.use '/vendor', express.static(path.join(app.get('root'), 'bower_components'))  
  app.use '/fonts', express.static(path.join(app.get('root'), 'bower_components','bootstrap','fonts'))  
  app.use '/font', express.static(path.join(app.get('root'), 'bower_components','font-awesome','font'))  

  app.use(app.router) 


# Request Handlers

app.options '*', (req,res) -> res.send(200)
app.get '/healthy', (req,res) -> res.send(200)
app.get '/', (req,res) -> res.render('app.html')


server = http.createServer(app)
server.listen app.get('port'), '0.0.0.0', ->
  console.log "App settings:", app.locals.settings  

module.exports = app