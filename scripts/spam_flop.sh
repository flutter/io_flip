#!/bin/bash
for ((n=0;n<30;n++))
do
  open -na "Google Chrome" --args --new-window --incognito http://localhost:8080
  sleep 1
done
