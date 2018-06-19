SYMBOL="CCTT"

echo "Creating token..."
CREATED=$(cleos get table everipediaiq $SYMBOL stat | grep $SYMBOL)
if [[ -z $CREATED ]]; then
    echo "Creating..."
    cleos push action everipediaiq create "[\"everipediaiq\", \"100000000000.000 $SYMBOL\"]" -p everipediaiq@active
else
    echo "Token exists. Skipping create"
fi

ISSUANCE=$(cleos get table everipediaiq everipediaiq accounts | grep $SYMBOL)
if [[ -z $ISSUANCE ]]; then
    echo "Issuing..."
    cleos push action everipediaiq issue "[\"everipediaiq\", \"10000000000.000 $SYMBOL\", \"initial supply\"]" -p everipediaiq@active
else
    echo "Token already issued. Skipping issue"
fi

for line in $(tail +2 iq_snapshot.csv | head -1000); do
    ACCOUNT=$(echo $line | tr "," "\n" | head -2 | tail -1)
    AMOUNT=$(echo $line | tr "," "\n" | tail -1)
    CURRENT_BALANCE=$(cleos get table everipediaiq $ACCOUNT accounts | grep $SYMBOL) 
    if [[ -z $CURRENT_BALANCE ]]; then
        echo "Airdropping $AMOUNT $SYMBOL to $ACCOUNT"
        cleos push action everipediaiq transfer "[\"everipediaiq\", \"$ACCOUNT\", \"$AMOUNT $SYMBOL\", \"airdrop\"]" -p everipediaiq@active
    else
        echo "Skipping $ACCOUNT"
    fi 
done

