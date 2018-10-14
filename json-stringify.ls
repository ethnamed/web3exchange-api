module.exports = (str, cb)->
    return cb "FATAL. Failed JSON. Expected object" if typeof! str isnt \Object
    try
        return cb null, JSON.stringify(str)
    catch err
        cb err