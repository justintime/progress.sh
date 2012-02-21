#!/bin/bash
#CMD="tail -n1 .progress | cut -d' ' -f1"
if [ -n "$1" ]; then
  CMD=$1
  if [ -n "$2" ]; then
    TOTAL=$2
    if [ ! $TOTAL -gt 0 ]; then
      echo "ARG2 should be an integer > 0."
      exit 1;
    fi
  else
    TOTAL=0
  fi
else 
  echo "ARG1 should be a command that generates an integer!"
  echo "ARG2 (optional) should be the end integer."
  exit 1;
fi

SLEEP=30
NOW=$(eval $CMD)
if [ $NOW -eq $NOW 2> /dev/null ]; then
  if [ ! $NOW -ge 0 ]; then
    echo "Running of '$CMD' produced output that is not greater than or equal to 0.";
    exit 1;
  fi
else 
    echo "Running of '$CMD' produced output that is not an integer.";
    exit 1;
fi
COUNT=0
AVGTOTAL=0
ETA="???"
while [ true ]; do
  sleep $SLEEP
  LATER=$(eval $CMD)
  RECS=$(echo "scale=2; ($LATER - $NOW) / $SLEEP" | bc -l)
  NOW=$LATER
  let COUNT=$COUNT+1
  AVGTOTAL=$(echo "scale=2; $AVGTOTAL + $RECS" | bc -l)
  AVG=$(echo "scale=2; $AVGTOTAL/$COUNT" | bc -l)
  if [ $TOTAL -gt 0 ]; then
    PERCENT=$(echo "scale=2; $LATER / $TOTAL * 100" | bc -l)
    if [ "$AVG" != "0" ]; then
      ETA=$(echo "scale=2; mins= ($TOTAL - $LATER)/ $AVG /60; if ( mins > 60 ) { print mins/60; print \" hrs\" } else {print mins;print \" mins\"}" | bc -l)
    fi
    echo -e "Current=$RECS/sec\tTotalAvg=$AVG/sec\tTotal=$LATER/$TOTAL $PERCENT%\t$ETA left"
  else
    echo -e "Current=$RECS/sec\tTotalAvg=$AVG/sec\tTotal=$LATER"
  fi
done
