module.exports = (str, cb)->
    return cb "FATAL. Expected string" if typeof! str isnt \String
    try
        return cb null, JSON.parse(str)
    catch err
        cb err