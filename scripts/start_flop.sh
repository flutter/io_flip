
echo ' ################################# '
echo ' ## Starting flop in local mode ## '
echo ' ################################# '

ENCRYPTION_KEY=$1
ENCRYPTION_IV=$2
RECAPTCHA_KEY=$3
APPCHECK_DEBUG_TOKEN=$4

cd flop && flutter run \
  -d chrome \
  --dart-define ENCRYPTION_KEY=$ENCRYPTION_KEY \
  --dart-define ENCRYPTION_IV=$ENCRYPTION_IV \
  --dart-define RECAPTCHA_KEY=$RECAPTCHA_KEY \
  --dart-define APPCHECK_DEBUG_TOKEN=$APPCHECK_DEBUG_TOKEN
