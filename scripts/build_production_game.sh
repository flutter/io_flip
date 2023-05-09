#!/bin/bash

ENCRYPTION_KEY=$1
ENCRYPTION_IV=$2
RECAPTCHA_KEY=$3

flutter build web \
  -t lib/main_production.dart \
  --web-renderer canvaskit \
  --dart-define SHARING_ENABLED=true \
  --dart-define ENCRYPTION_KEY=$ENCRYPTION_KEY \
  --dart-define ENCRYPTION_IV=$ENCRYPTION_IV \
  --dart-define RECAPTCHA_KEY=$RECAPTCHA_KEY \
  --dart-define ALLOW_PRIVATE_MATCHES=false
