SWIFT_BUILD_FLAGS=--configuration release

EXECUTABLE=$(shell swift build $(SWIFT_BUILD_FLAGS) --show-bin-path)/dumpling-cli
BINARIES_FOLDER=/usr/local/bin

.PHONY: all clean build install package test uninstall docs


build:
	swift build $(SWIFT_BUILD_FLAGS)

clean:
	swift package clean

install: build
	install -d "$(BINARIES_FOLDER)"
	install "$(EXECUTABLE)" "$(BINARIES_FOLDER)"


uninstall:
	rm -f "$(BINARIES_FOLDER)/dumpling-cli"