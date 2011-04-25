fs            = require 'fs'
path          = require 'path'
{spawn, exec} = require 'child_process'

run = (args) ->
    proc = spawn "coffee", args
    proc.stderr.on "data", (buffer) -> console.log buffer.toString()
    proc.on "exit", (status) -> process.exit(1) if status != 0

task "prepare", "prepare the output directories", ->
    exec(
        "mkdir -p lib", (err, stdout, stderr) ->
            if err then console.log stderr.trim()
        )

task "compile", "compile all the coffeescript files into javascript", ->
    invoke 'prepare'

    files = fs.readdirSync "src"
    files = ("src/" + file for file in files when file.match(/\.coffee$/))
    run ['-c', '-o', 'lib'].concat(files)
