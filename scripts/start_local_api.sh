#!/bin/bash

export FB_APP_ID=top-dash-dev
export GAME_URL=http://localhost:8080/
export USE_EMULATOR=true
export ENCRYPTION_KEY=X9YTchZdcnyZTNBSBgzj29p7RMBAIubD
export ENCRYPTION_IV=FxC21ctRg9SgiXuZ
export INITIALS_BLACKLIST_ID=MdOoZMhusnJTcwfYE0nL
export PROMPT_WHITELIST_ID=MIsaP8zrRVhuR84MLEic
export FB_STORAGE_BUCKET=top-dash-dev.appspot.com
export SCRIPTS_ENABLED=true

echo ' ######################## '
echo ' ## Starting dart frog ## '
echo ' ######################## '

cd api && dart_frog dev
