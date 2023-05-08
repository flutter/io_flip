#!/bin/bash
PORT=$1
for ((n=0;n<30;n++))
do
  open -na "Google Chrome" --args --new-window --incognito http://localhost:$PORT/index.html
  sleep 1
done
