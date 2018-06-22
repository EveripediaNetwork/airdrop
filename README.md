# Everipedia IQ Airdrop

This repository contains all code related to the Everipedia IQ airdrop. It's been designed in a way that it should be easy to swap in your own token airdrop for IQ. 

## Generating a snapshot. 

The `snapshot_generator.py` script generates an airdrop snapshot from the EOS genesis snapshot. If you wish to use some other base snapshot than the EOS genesis snapshot, swap out the `eos_snapshot.csv` file with your custom snapshot. 

The script requires Pandas, so install that with:

```py
pip install pandas
```

There are a couple configs you will have to modify before running the script. Open the script, at the top you will see the following:

```py
DECIMAL_PRECISION=3
EOS_SNAPSHOT_FILE='eos_snapshot.csv'
TOKEN_MULTIPLIER=5.1 # How many airdropped tokens to send per EOS
OUTPUT_FILE='iq_snapshot.csv'
USE_BLACKLIST=True
```

The default settings are the settings for the IQ airdrop. You will likely have to modify the `TOKEN_MULTIPLIER` and `OUTPUT_FILE` at minimum. 

The blacklist contains a series of exchange addresses that specifically have not announced support for the Everipedia IQ airdrop. The addresses are contained in `blacklist.txt`. You can modify that file to use your own blacklist or set `USE_BLACKLIST=False`.

The whitelist (`whitelist.txt`) is a separate list that contains a series of exchange addresses that have announced support for the IQ airdrop. The only purpose of the whitelist is to verify that none of the whitelisted addresses are in the blacklist. If there are, the script will throw an error. 

To run the snapshot generator:

```py
python snapshot_generator.py
```

The airdrop snapshot will be saved to `OUTPUT_FILE`

## Deploying the Contract

Before running the airdrop, you must deploy the `eosio.token` contract to your account. If it is not you can do so with the following commands. Make sure your wallet is unlocked and you have imported the appropriate keys before deploying the contract.

```bash
TOKEN_WAST=~/eos/build/contracts/eosio.token/ # replace this with the folder containing your eosio.token WAST files
ISSUER=iqairdropper # replace this with the account that will be issuing the tokens
cleos set contract $ISSUER $TOKEN_WAST
```

## Airdropping

The airdrop script (`airdrop.sh`) contains a couple settings that need to be modified.

```bash
SYMBOL="DRYB"
ISSUER="iqairdropper"
SNAPSHOT_FILE="iq_snapshot.csv"
```

The `SYMBOL` is the symbol of the asset that will be used on-chain. A `SYMBOL` can only be used once per contract, so if you want to re-use a symbol that you have already created, you will have to re-deploy the contract to a different account. 

The `ISSUER` should be the same as the `ISSUER` account you deployed the contract to. 

The `SNAPSHOT_FILE` should match the `OUTPUT_FILE` from `snapshot_generator.py`

To airdrop:

```bash
./airdrop.sh
```

The airdrop will take ~2 hours, so I would recommend using systemd or some other tool to run the airdrop in the background.

The airdrop consumes the following EOS system resources. Make sure you have enough EOS staked for RAM, NET, and CPU before airdropping:

![Airdrop Analytics](img/airdrop_analytics.png)

## Validating the Airdrop

Once you have completed the airdrop, you can validate the account balances with the `validate_airdrop.sh` script. Modify the configs at the top of the script:

```bash
SYMBOL="DRYC"
ISSUER="iqairdropper"
VALIDATIONS=1000
```

The `SYMBOL` and `ISSUER` should match the configs from `airdrop.sh`. The script runs validations in a loop. Each validation consists of selecting a random account and verifying its balance against the snapshot. The script can execute about 50 validations per second. Using more validations than the default is recommended but will be slow.
