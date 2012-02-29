imap = require "imap"
mailparser = require "mailparser"
request = require "request"

fs = require "fs"
config = JSON.parse fs.readFileSync "#{process.cwd()}/config.json", "utf-8"

server = new imap.ImapConnection
    username: config.username
    password: config.password
    host: config.imap.host
    port: config.imap.port
    secure: config.imap.secure

exitOnErr = (err) ->
    console.log "Error!"
    console.error err

post_me = (json, callback) ->
    request.post
            url: config.post_url
            json: json
        , callback

on_message = (message) ->
    parser = new mailparser.MailParser()

    parser.on "end", (mail) ->
        post_me(mail, () -> console.log('posted!'))

    message.on "data", (data) ->
        parser.write data.toString()
        parser.end()

do_connect = () ->
    server.connect (err) ->
        exitOnErr err if err

        server.openBox "INBOX", false, (err, box) ->
            server.search ["UNSEEN"], (err, results) ->
                exitOnErr(err) if err

                unless results.length
                    console.log "No unread messages"
                    server.logout()

                    setTimeout(() ->
                        do_connect()
                    , config.tick)

                    return

                fetch = server.fetch results,
                    request:
                        body: "full"
                        headers: false
                
                fetch.on "message", (message) ->
                    on_message(message)

                server.addFlags results, 'Seen'

                fetch.on "end", ->
                    server.logout()

                    setTimeout(() ->
                        do_connect()
                    , config.tick)

do_connect()