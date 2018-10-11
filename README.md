## Web3 Exchange API

### Install 

```
npm i web3exchange-api
```

### How to use

Generate the private key [here](https://www.bitaddress.org/bitaddress.org-v3.3.0-SHA256-dec17c07685e1870960903d8f58090475b25af946fe95a734f88408cef4aa194.html) or another place trusted by you.

Get Address 

```Javascript 

var builder = require('web3exchange-api');

var privateKey = "cPBn5A4ikZvBTQ8D7NnvHZYCAxzDZ5Z2TSGW2LkyPiLxqYaJPBW4";
var apiUrl = "http://ethnamed.io:8081";

var address = builder.getAddress(privateKey);

```

Contact to API's admin and privide him your address
He have to put your public address into the `config.json/recaptcha/whitelist` on the server

Init the API

```Javascript

var builder = require('web3exchange-api');

var privateKey = "cPBn5A4ikZvBTQ8D7NnvHZYCAxzDZ5Z2TSGW2LkyPiLxqYaJPBW4";
var apiUrl = "http://ethnamed.io:8081";

api = builder.createApi(apiUrl, privateKey);



api.convert({ from, to, value, address }, cb)

//...

```

### Crypto To Fiat

```Javascript

var request = {
    from: "ETH",
    to: "USD",
    value: "1", //ETH
    address: "0000 0000 0000 0000"
}

var cb = (err, data) {
    //Send 1 ETH Here
    console.log(data.address);
}

api.convert(request, cb);


```


### Fiat To Crypto

```Javascript

var request = {
    from: "USD",
    to: "ETH",
    value: "100", //USD
    address: "0xbd7ac0f279dc56b61fb10faeaa7fd8da54e92408" //Your ETH address to receive coins
}

var cb = (err, data) {
    console.log(data.checkout_url);
}

api.convert(request, cb);

```
