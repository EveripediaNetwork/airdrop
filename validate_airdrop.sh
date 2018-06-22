SYMBOL="DRYC"
ISSUER="iqairdropper"
VALIDATIONS=1000

NUM_LINES=$(wc -l iq_snapshot.csv | awk '{print $1}')
FAIL_FLAG=false
for i in `seq 1 $VALIDATIONS`; do 
    RAND=$(openssl rand 4 | od -DAn)
    RAND=$((RAND % $NUM_LINES))
    LINE=$(sed "${RAND}q;d" iq_snapshot.csv)
    ACCOUNT=$(echo $LINE | tr "," "\n" | head -2 | tail -1)
    AMOUNT=$(echo $LINE | tr "," "\n" | tail -1)
    CURRENT_BALANCE=$(cleos get table $ISSUER $ACCOUNT accounts | grep $SYMBOL | grep -Eo '[0-9]+\.[0-9]+')
    #echo "$ACCOUNT $AMOUNT $CURRENT_BALANCE"
    if [ "$AMOUNT" != "$CURRENT_BALANCE" ]; then
        echo "$ACCOUNT failed. Should have $AMOUNT $SYMBOL"
        FAIL_FLAG=true
    fi
done
if [ $FAIL_FLAG = "false" ]; then
    echo "All Tests Passed"
fi
