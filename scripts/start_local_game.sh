
echo ' ################################# '
echo ' ## Starting game in local mode ## '
echo ' ################################# '

flutter run \
  -d chrome \
  --target lib/main_local.dart \
  --flavor development \
  --dart-define ENCRYPTION_KEY=X9YTchZdcnyZTNBSBgzj29p7RMBAIubD \
  --dart-define ENCRYPTION_IV=FxC21ctRg9SgiXuZ \
  --dart-define RECAPTCHA_KEY=6LeafHolAAAAAH-kou5bR2y4gtEOmFXdd6pM4cJz \
  --dart-define APPCHECK_DEBUG_TOKEN=1E88A2CC-8D94-4ADC-A156-A63DBA49627D
