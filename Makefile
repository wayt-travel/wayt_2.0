SHELL=/bin/bash

.SHELLFLAGS = -ec
.ONESHELL:

FASTLANE_ENV := "development"
PREPARE_BUILD := true

.PHONY: clean # Clean project files
clean:
	$(call h,Cleaning project files...)
	fvm flutter clean
	fvm flutter pub get
	$(call h,Project cleaned)

.PHONY: clean-hard
clean-hard:
	$(call h,Cleaning project files...)
	@fvm flutter clean
	rm -rf wayt_app/ios/.symlinks
	rm -rf wayt_app/ios/Pods
	rm wayt_app/ios/Podfile.lock
	rm wayt_app/pubspec.lock
	fvm flutter pub get
	@fvm flutter precache --ios
	@cd wayt_app/ios
	@pod install --repo-update
	$(call h,Project cleaned)

.PHONY: publish-ios
publish-ios: 
	$(call h,Publishing iOS app on the App Store Connect)
	@fvm flutter precache --ios
	@cd app/ios
	@pod install
	@bundle install
	@bundle exec fastlane deploy --env $(FASTLANE_ENV) prepare_build:$(PREPARE_BUILD)
	$(call h,iOS app published on the App Store Connect)		

.PHONY: publish-android
publish-android:
	$(call h,Publishing Android app on the Play Store Console)
	@cd app/android
	@bundle install
	@bundle exec fastlane deploy --env $(FASTLANE_ENV) prepare_build:$(PREPARE_BUILD)
	$(call ok,Android app published on the Play Store Console)
