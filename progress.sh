#!/bin/bash
#CMD="tail -n1 .progress | cut -d' ' -f1"
CMD=$1
if [ -n "$2" ]; then
    TOTAL=$2
fi
SLEEP=30
NOW=$(eval $CMD)
COUNT=0
AVGTOTAL=0
while [ true ]; do
	sleep $SLEEP
	LATER=$(eval $CMD)
	RECS=$(echo "scale=2; ($LATER - $NOW) / $SLEEP" | bc -l)
	NOW=$LATER
	let COUNT=$COUNT+1
	AVGTOTAL=$(echo "scale=2; $AVGTOTAL + $RECS" | bc -l)
	AVG=$(echo "scale=2; $AVGTOTAL/$COUNT" | bc -l)
	PERCENT=$(echo "scale=2; $LATER / $TOTAL * 100" | bc -l)
        if [ "$AVG" != "0" ]; then
            ETA=$(echo "scale=2; mins= ($TOTAL - $LATER)/ $AVG /60; if ( mins > 60 ) { print mins/60; print \" hrs\" } else {print mins;print \" mins\"}" | bc -l)
        else
            ETA="???"
        fi
	echo -ne "Current=$RECS/sec\tTotalAvg=$AVG/sec\tTotal=$LATER/$TOTAL $PERCENT%\t$ETA left\r"
done
