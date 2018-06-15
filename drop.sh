for line in $(cat snapshot.csv); do
	ACCOUNT=$(echo $line | tr "," "\n" | head -2 | tail -1 | tr --delete '"')
	AMOUNT=$(echo $line | tr "," "\n" | tail -1 | tr --delete '"')
	#IQ_AMOUNT=$(echo "$AMOUNT * 5" | bc -l | xargs printf "%0.3f" )
	echo "$ACCOUNT,$IQ_AMOUNT"
done
