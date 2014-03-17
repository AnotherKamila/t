express = require 'express'
mongo   = require 'mongodb'
require 'datejs'  # modifies the Date prototype :-/ but it works...

task = (o) ->
    if o.task?
        o.text = o.task.replace /#(\w+)/g, (_,m) -> o.tags ?= []; o.tags.push m; return ''
        o.text = o.text.replace /@(\w+)/,  (_,m) -> o.loc = m; return ''
        ts = o.text.split /\s+/; len = ts.length
        [ d, t ] = [ [0,j], [j,len] ] if Date.parse ts.slice(j,len).join ' ' for j in [len..0]
        [ d, t ] = [ [i,len], [0,i] ] if Date.parse ts.slice(0,i).join ' '   for i in [0..len]
        o.text = ts.slice(t[0],t[1]).join ' '; o.date = ts.slice(d[0],d[1]).join ' '
    o.date = Date.parse o.date if typeof o.date == 'string'
    delete o.task
    return o

by_id = (id) -> { _id: new mongo.ObjectID id }

mongo.MongoClient.connect process.env.MONGO_URL, (err, db) ->
    console.log err if err?
    todos = db.collection 'todos'

    app = express().use(express.basicAuth process.env.USER, process.env.PASS)
                   .use(express.json())
    
    app.get  '/',    (req, res) -> todos.find().toArray (e, r) -> res.json e ? r
    app.post '/',    (req, res) -> todos.insert (task req.body), (e, r) -> res.send e ? r
    app.del  '/:id', (req, res) -> todos.remove (by_id req.params.id), (e, r) -> res.send e ? { num_removed: r }
    app.put  '/:id', (req, res) -> t = task req.body; todos.update (by_id req.params.id), {"$set": t}, (e, r) -> res.send e ? t

    app.listen process.env.PORT, -> console.log "listening on port #{process.env.PORT}"
