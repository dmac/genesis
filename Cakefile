{exec} = require "child_process"

http = require "http"
fs = require "fs"
stitch = require "stitch"

build = (callback) ->
  exec "rm -f lib/* && coffee -c -o lib src", (error, stdout, stderr) ->
    if error != null
      console.log stderr
    else
      callback() if callback?

task "build", "Build lib/ from src/", -> build()

task "serve", "Serve a sample page", ->
  http.createServer((req, res) ->
    switch req.url
      when "/"
        html = fs.readFileSync "example/index.html"
        res.end html
      when "/index.css"
        css = fs.readFileSync "example/index.css"
        res.end css
      when "/genesis.js"
        build ->
          package = stitch.createPackage
            paths: ["#{__dirname}/lib", "#{__dirname}/node_modules"]
          package.compile (err, genesis) -> res.end genesis
  ).listen 8000, "localhost"
  console.log "Server running at http://localhost:8000"

task "test", "Run a test", ->
  build ->
    {Generator} = require "./lib/genesis"
