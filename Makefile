ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
IOS_SIMULATOR = "iOS Simulator,name=iPhone 12 Pro,OS=14.4"
DERIVED_DATA_DIR=$(ROOT_DIR)/.build/DerivedData

.PHONY: pre_checks_macos default

default:

pre_checks_macos:
# 	ifeq (, $(shell which xcpretty))
# 	$(error "No xcpretty in PATH, consider doing gem install xcpretty")
# 	endif

build:
	swift build

test: 
	swift test
	(cd IntegrationTests && swift test)

test-swift:
	swift test --enable-test-discovery

test-ios: pre_checks_macos
	set -o pipefail && \
	xcodebuild test \
		-derivedDataPath $(DERIVED_DATA_DIR) \
		-scheme Dumpling \
		-destination platform=$(IOS_SIMULATOR) | xcpretty

test-macos: pre_checks_macos
	set -o pipefail && \
	xcodebuild test \
		-derivedDataPath $(DERIVED_DATA_DIR) \
		-scheme Dumpling \
		-destination platform="macOS" | xcpretty

test-integration-swift:
	cd IntegrationTests && swift test --enable-test-discovery

test-integration-ios: pre_checks_macos
	cd IntegrationTests && \
	set -o pipefail && \
	xcodebuild test \
		-derivedDataPath $(DERIVED_DATA_DIR) \
		-scheme "DumplingIntegrationTests-Package" \
		-destination platform=$(IOS_SIMULATOR) | xcpretty

test-integration-macos: pre_checks_macos
	cd IntegrationTests && \
	set -o pipefail && \
	xcodebuild test \
		-derivedDataPath $(DERIVED_DATA_DIR) \
		-scheme "DumplingIntegrationTests-Package" \
		-destination platform="macos" | xcpretty

test-linux:
	docker run \
		--rm \
		-v "$(PWD):$(PWD)" \
		-w "$(PWD)" \
		swift:5.3 \
		bash -c 'make test-swift test-integration-swift'

test-all: test-macos test-ios
test-integration-all: test-integration-ios test-integration-macos

clean:
	swift package clean
	(cd ItegrationTests && swift package clean)