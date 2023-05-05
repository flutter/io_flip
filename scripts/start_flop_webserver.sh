
echo ' ################################# '
echo ' ## Starting flop in local mode ## '
echo ' ################################# '

cd flop && flutter run \
  -d web-server \
  --release \
  --dart-define ENCRYPTION_KEY=Bx677bkZEXvmiqzKXoph2mp3kDoqexkV \
  --dart-define ENCRYPTION_IV=rPMNKz2YzWQjjjMi \
  --dart-define RECAPTCHA_KEY=6LeafHolAAAAAH-kou5bR2y4gtEOmFXdd6pM4cJz \
  --dart-define APPCHECK_DEBUG_TOKEN=1E88A2CC-8D94-4ADC-A156-A63DBA49627D
