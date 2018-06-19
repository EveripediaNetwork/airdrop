for line in $(head account_balances.csv); do
	ACCOUNT=$(echo $line | tr "," "\n" | head -1)
	AMOUNT=$(echo $line | tr "," "\n" | tail -1)
	CURRENT_BALANCE=$(cleos get account $ACCOUNT | grep IQ)
    echo $CURRENT_BALANCE
done
