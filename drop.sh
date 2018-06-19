SYMBOL="CCTP"

echo "Creating token..."
cleos push action everipediaiq create "[\"everipediaiq\", \"100000000000.000 $SYMBOL\"]" -p everipediaiq@active

ISSUANCE=$(cleos get table everipediaiq everipediaiq accounts | grep $SYMBOL)
if [[ -z $ISSUANCE ]]; then
    echo "Issuing..."
    cleos push action everipediaiq issue "[\"everipediaiq\", \"10000000000.000 $SYMBOL\", \"initial supply\"]" -p everipediaiq@active
fi

for line in $(head -30 account_balances.csv); do
    ACCOUNT=$(echo $line | tr "," "\n" | head -1)
    AMOUNT=$(echo $line | tr "," "\n" | tail -1)
    CURRENT_BALANCE=$(cleos get table everipediaiq $ACCOUNT accounts | grep $SYMBOL) 
    echo $ACCOUNT
    echo $AMOUNT
    if [[ -z $CURRENT_BALANCE ]]; then
        echo "Airdropping $AMOUNT $SYMBOL to $ACCOUNT"
        cleos push action everipediaiq transfer "[\"everipediaiq\", \"$ACCOUNT\", \"$AMOUNT $SYMBOL\", \"airdrop\"]" -p everipediaiq@active
    else
        echo "Skipping $ACCOUNT"
    fi 
done

