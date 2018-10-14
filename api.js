// Generated by LiveScript 1.6.0
(function(){
  var post, guid, jsonStringify, jsonParse, bitcore, Message, createSignature, genericCall, kycBuilder, convertBuilder, createClientid, getAddress, createApi, out$ = typeof exports != 'undefined' && exports || this;
  post = require('superagent').post;
  guid = require('./guid.js');
  jsonStringify = require('./json-stringify.js');
  jsonParse = require('./json-parse.js');
  bitcore = require('bitcore-lib');
  Message = require('bitcore-message');
  createSignature = function(privateKeyHex, request, cb){
    var privateKey;
    privateKey = bitcore.PrivateKey.fromWIF(privateKeyHex);
    return jsonStringify(request, function(err, str){
      var signature;
      if (err != null) {
        return cb(err);
      }
      signature = Message(str).sign(privateKey);
      if (err != null) {
        return cb(err);
      }
      return cb(null, signature);
    });
  };
  genericCall = function(fields, name){
    return function(config){
      return function(request, cb){
        var apiUrl, privateKey, i$, ref$, len$, item;
        apiUrl = config.apiUrl, privateKey = config.privateKey;
        for (i$ = 0, len$ = (ref$ = fields).length; i$ < len$; ++i$) {
          item = ref$[i$];
          if (request[item] == null) {
            return cb("`" + item + "` is required");
          }
        }
        return createSignature(privateKey, request, function(err, signature){
          if (err != null) {
            return cb(err);
          }
          return post(apiUrl + "/" + name, request).set('signature', signature).end(function(err, data){
            if (err != null) {
              return cb(err);
            }
            return jsonParse(data.text, function(err, result){
              if (err != null) {
                return cb(err);
              }
              return cb(null, result);
            });
          });
        });
      };
    };
  };
  kycBuilder = genericCall(['firstname', 'lastname', 'bill', 'photo', 'clientid'], 'kyc');
  convertBuilder = genericCall(['to', 'from', 'value', 'address', 'clientid'], 'exchange');
  out$.createClientid = createClientid = guid;
  out$.getAddress = getAddress = function(key){
    var privateKey;
    privateKey = bitcore.PrivateKey.fromWIF(key);
    return privateKey.toAddress(bitcore.Networks.livenet).toString();
  };
  out$.createApi = createApi = function(arg$, cb){
    var apiUrl, privateKey, config, convert, kyc;
    apiUrl = arg$.apiUrl, privateKey = arg$.privateKey;
    if (apiUrl == null) {
      return cb("apiUrl is required");
    }
    if (privateKey == null) {
      return cb("private-key is required");
    }
    config = {
      apiUrl: apiUrl,
      privateKey: privateKey
    };
    convert = convertBuilder(config);
    kyc = kycBuilder(config);
    return cb(null, {
      convert: convert,
      kyc: kyc
    });
  };
}).call(this);
