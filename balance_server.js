var fs = require('fs');
const express = require('express')
const app = express()

// load snapshot into memory
var snapshot = {}
var csv = fs.readFileSync('iq_snapshot.csv', 'ascii');
var lines = csv.split('\n');
lines.slice(1).forEach(function (line) {
    var cols = line.split(',');
    snapshot[cols[2]] = cols[4];
});

app.get('/balance/:EOSpubkey', (req, res) => {
    var balance = snapshot[req.params.EOSpubkey];
    if (balance)
        res.send(balance);
    else
        throw new Error("EOS pubkey not found in snapshot");
});

app.listen(5000, () => console.log('Listening on port 5000...'));
