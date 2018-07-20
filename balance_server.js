var fs = require('fs');
const express = require('express')
const https = require('https');
const app = express()
const morgan = require('morgan')

// load snapshot into memory
var snapshot = {}
var csv = fs.readFileSync('iq_snapshot.csv', 'ascii');
var lines = csv.split('\n');
lines.slice(1).forEach(function (line) {
    var cols = line.split(',');
    if (snapshot[cols[2]]) // account for duplicate public keys
        snapshot[cols[2]] += cols[4]; 
    else
        snapshot[cols[2]] = cols[4];
});

// Logging
app.use(morgan('combined'))

// CORS
app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
});


app.get('/balance/:EOSpubkey', (req, res) => {
    var balance = snapshot[req.params.EOSpubkey];
    if (balance)
        res.send(balance);
    else {
        res.status(500);
        console.error("EOS pubkey not found in snapshot");
        res.send("EOS pubkey not found in snapshot");
    }
});

app.get('/iq/outstanding_supply', (req, res) => {
    res.send("10000000000.000");
});

https.createServer({
    key: fs.readFileSync('certs/privkey.pem'),
    cert: fs.readFileSync('certs/cert.pem')
}, app).listen(5000, '0.0.0.0');
