docker_flutter_web:
	 @docker build \
      --file ./dockerfiles/flutter_web.dockerfile \
      -t flutter-pos-web-nginx \
      .


version: ## Check flutter version
	@flutter --version


fvm-version:
	fvm flutter --version


format: ## Format the code
	@dart format -l 100 lib/ test/


# first calls format
fix: format ## Fix the code
	@dart fix --apply lib


get: ## Get the dependencies
	@flutter pub get


# first calls "get"
upgrade-major: get ## Upgrade to major versions
	@flutter pub upgrade --major-versions


outdated: get ## Check for outdated dependencies
	@flutter pub outdated --show-all --dev-dependencies --dependency-overrides --transitive --no-prereleases


dependencies: get ## Check outdated dependencies
	@flutter pub outdated --dependency-overrides \
		--dev-dependencies --prereleases --show-all --transitive


analyze: get ## Analyze the code
	@dart format --set-exit-if-changed -l 100 -o none lib/ test/
	@flutter analyze --fatal-infos --fatal-warnings lib/ test/


l10n: ## Generate localization
	@dart pub global activate intl_utils
	@dart pub global run intl_utils:generate
	@flutter gen-l10n --arb-dir lib/src/common/localization --output-dir lib/src/common/localization/generated --template-arb-file intl_en.arb


fluttergen: ## Generate assets
	@dart pub global activate flutter_gen
	@fluttergen -c pubspec.yaml


generate: get l10n format fluttergen ## Generate the code
	@dart run build_runner build --delete-conflicting-outputs --release


generate-dev:
	@dart run build_runner watch


clean:
	@flutter clean


build-android-app-bundle: clean get
	@flutter build appbundle --dart-define-from-file=env/env.json


build-android-apk: clean get
	@flutter build apk --release --dart-define-from-file=env/env.json


build-web: clean get
	@flutter build web --release --dart-define-from-file=env/env.json


web-deploy: build-web
	@firebase deploy



# add correct local ip-address
WEB_HOST ?= 192.168.100.70
WEB_PORT ?= 4000
ENV_FILE ?= env/env.json

# then run this
web-serve-local: ## Run Flutter web server locally
	@flutter run -d web-server \
		--release \
		--dart-define-from-file=$(ENV_FILE) \
		--dart-define=FAKE=true \
		--web-port=$(WEB_PORT) \
		--web-hostname=$(WEB_HOST)




build-ios: ## Build the ios app
	@flutter build ios --release --dart-define-from-file=env/env.json



build-macos: ## Build the macos app
	@flutter build macos --release --dart-define-from-file=env/env.json



build-linux: ## Build the linux app
	@flutter build linux --release --dart-define-from-file=env/env.json



build-windows: ## Build the windows app
	@flutter build windows --release --dart-define-from-file=env/env.json