should    = require 'should'
express   = require 'express'
app       = express.createServer()
eyes      = require 'eyes'
emitter   = new(require('events').EventEmitter)


###
# Dummy Server to listen for requests 
###
app.configure ->
  app.use(express.bodyParser())

app.post '/example', (req, res) ->
  emitter.emit '/request/received', req.body


###
# Test 
###
describe 'Application', ->
  before (done) ->
    app.listen 3001, ->
      console.log "server listening on port #{app.address().port}"
      done()
  after ->
    app.close()

  it 'should just freeaking work', (done)->
    require('../read')
    # listen for it only once, don't care about the others
    emitter.once '/request/received', (content) ->
      content.should.have.property 'headers'
      content.headers.should.have.property 'return-path'
      done()
      


