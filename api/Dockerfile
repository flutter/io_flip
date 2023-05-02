# Official Dart image: https://hub.docker.com/_/dart
# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.17)
FROM dart:beta AS build

WORKDIR /app

# Copy Dependencies
COPY packages/card_renderer ./packages/card_renderer
COPY packages/cards_repository ./packages/cards_repository
COPY packages/config_repository ./packages/config_repository
COPY packages/db_client ./packages/db_client
COPY packages/encryption_middleware ./packages/encryption_middleware
COPY packages/firebase_cloud_storage ./packages/firebase_cloud_storage
COPY packages/game_domain ./packages/game_domain
COPY packages/game_script_machine ./packages/game_script_machine
COPY packages/image_model_repository ./packages/image_model_repository
COPY packages/jwt_middleware ./packages/jwt_middleware
COPY packages/language_model_repository ./packages/language_model_repository
COPY packages/leaderboard_repository ./packages/leaderboard_repository
COPY packages/match_repository ./packages/match_repository
COPY packages/prompt_repository ./packages/prompt_repository
COPY packages/scripts_repository ./packages/scripts_repository

# Install Dependencies
RUN dart pub get -C packages/card_renderer
RUN dart pub get -C packages/cards_repository
RUN dart pub get -C packages/db_client
RUN dart pub get -C packages/encryption_middleware
RUN dart pub get -C packages/firebase_cloud_storage
RUN dart pub get -C packages/game_domain
RUN dart pub get -C packages/game_script_machine
RUN dart pub get -C packages/image_model_repository
RUN dart pub get -C packages/jwt_middleware
RUN dart pub get -C packages/language_model_repository
RUN dart pub get -C packages/leaderboard_repository
RUN dart pub get -C packages/match_repository
RUN dart pub get -C packages/prompt_repository
RUN dart pub get -C packages/scripts_repository

# Resolve app dependencies.
COPY pubspec.* ./
RUN dart pub get

# Copy app source code and AOT compile it.
COPY . .
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
RUN dart compile exe bin/server.dart -o bin/server

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/
COPY --from=build /app/public /public/

# Start server.
CMD ["/app/bin/server"]
