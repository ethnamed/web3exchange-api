require! {
  \superagent : { post }
  \./guid.js
  \./json-parse.js
  \bitcore-lib : bitcore
  \bitcore-message : Message
}

create-signature = (private-key, request, cb)->
    err, str <- json-parse request
    return cb err if err?
    signature = Message(str).sign private-key
    return cb err if err?
    cb null, signature

generic-call = (fields, name)-> (config)-> (request, cb)->
    { api-url, private-key } = config
    for item in fields
        return cb "`#{item}` is required" if not request[item]?
    err, signature <- create-signature private-key, request
    return cb err if err?
    err, data <- post "#{api-url}/#{name}", request .set \signature, signature .end
    return cb err if err?
    err, result <- json-parse data.text
    return cb err if err?
    cb null, result

kyc-builder     = generic-call <[ firstname lastname bill photo clientid ]> , \kyc

convert-builder = generic-call <[ to from value address clientid ]> , \exchange


export create-clientid = guid

export get-address = (key)->
    private-key = bitcore.PrivateKey.fromWIF key
    return private-key.to-address bitcore.Networks.livenet .to-string!

export create-api = (api-url, private-key)->
    config = { api-url, private-key }
    convert = convert-builder config
    kyc = kyc-builder config
    { convert, kyc }