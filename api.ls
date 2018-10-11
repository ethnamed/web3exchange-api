require! {
  \superagent : { post }
  \./guid.js
  \./json-parse.js
  \bitcore-lib : bitcore
  \bitcore-message : Message
}

create-signature = (request, cb)->
    err, str <- json-parse request
    return cb err if err?
    signature = Message(str).sign private-key
    return cb err if err?
    cb null, signature

convert-builder = (config) -> ({ from, to, value, address }, cb)->
    { api-url } = config
    clientid = guid!
    request = { to, from, value, address, clientid }
    err, signature <- create-signature request
    return cb err if err?
    err, data <- post "#{api-url}/exchange", request .set \signature, signature .end
    return cb err if err?
    err, result <- json-parse data.text
    return cb err if err?
    cb null, result


export get-address = (key)->
    private-key = bitcore.PrivateKey.fromWIF key
    return private-key.to-address bitcore.Networks.livenet .to-string!

export create-api = (api-url)->
    config = { api-url }
    convert = convert-builder config
    { convert }