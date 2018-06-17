from flask import Flask, Response
app = Flask(__name__)

# load snapshot into memory
snapshot = {}
with open('iq_snapshot.csv', 'r') as f:
    lines = f.read().split('\n')
    for line in lines[1:-1]:
        cols = line.split(',')
        snapshot[cols[2]] = cols[4]

@app.route('/balance/<path:EOSpubkey>')
def balance(EOSpubkey):
    resp = Response(snapshot[EOSpubkey])
    resp.headers['Access-Control-Allow-Origin'] = '*'
    return resp

if __name__ == '__main__':
    context = ('certs/cert.pem', 'certs/privkey.pem')
    app.run(host="0.0.0.0", port="5000", debug=False, ssl_context=context)
