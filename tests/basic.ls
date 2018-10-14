require! {
  \../../web3t.ls
  \../api.ls : { create-api, create-clientid }
  \bip39 : { generate-mnemonic }
  \../json-parse.ls
}

crypto-to-fiat = (config, { from, to, value, address }, cb)->
    err, api <- create-api { config.api-url, config.private-key }
    return cb err if err?
    { convert } = api
    clientid = create-clientid!
    err, result <- convert { to, from, value, address, clientid }
    return cb err if err?
    { address } = result
    return cb "address is expected" if not address?
    { create-account, get-balance, send-transaction } = web3t.eth
    err, account <- create-account { config.mnemonic, index: 0 }  
    return cb err if err?
    err, balance <- get-balance { account }
    return cb err if err?
    return cb "balance should not be an zero" if balance is \0
    err, tx <- send-transaction { to: address, account, amount: value }
    return cb err if err?
    return cb "tx is expected" if not tx?
    <- set-timeout _, 2000
    cb null

fiat-to-crypto = (config, { from, to, value }, cb)->
    err, api <- create-api { config.api-url, config.private-key }
    return cb err if err?
    { convert } = api
    mnemonic = generate-mnemonic!
    { create-account, get-balance, send-transaction } = web3t.eth
    err, account <- create-account { config.mnemonic, index: 0 }
    return cb err if err?
    clientid = create-clientid!
    err, result <- convert { to, from, value, account.address, clientid }
    return cb err if err?
    <- set-timeout _, 10000
    err, balance <- get-balance { account }
    return cb err if err?
    return cb "balance should not be an zero" if balance is \0
    cb null

run-tests = (config, cb)->
    err <- crypto-to-fiat config, { from: \ETH, to: \USD, value: "1", address: '0000 0000 0000 0000' }
    return cb err if err?
    return cb null #exit
    err <- fiat-to-crypto config, { from: \USD, to: \ETH, value: "100" }
    return cb err if err?
    cb null

run = (cb)->
  api-url = \http://ethnamed.io:8081
  private-key = \cPBn5A4ikZvBTQ8D7NnvHZYCAxzDZ5Z2TSGW2LkyPiLxqYaJPBW4
  mnemonic = "xmr bch btg ltc eth eos xem ada dash btc zec bcn"
  err <- run-tests { api-url, private-key, mnemonic }
  cb err

err <- run
console.log err