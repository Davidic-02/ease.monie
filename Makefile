# Flutter development commands
.PHONY: runner clean get analyze test build watch

runner:
	flutter pub run build_runner build --delete-conflicting-outputs

watch:
	flutter pub run build_runner watch

clean:
	flutter clean
	
get:
	flutter pub get

analyze:
	flutter analyze

test:
	flutter test

setup: clean get

build-dev:
	flutter build apk --debug

build-prod:
	flutter build apk --release