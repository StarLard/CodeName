# CodeName
A command line tool for converting between common programming naming conventions.

## Installation

1. Clone the respository
2. `cd` into the repository directory
3. Build the binary with `swift build --configuration release`
4. Copy the binary from the build directory into your path: `cp -f .build/release/codename /usr/local/bin/codename`

## Usage

Convert between namings with the `--new-convention` and `--new-convention` options:
```
$ codename --new-convention --new-convention=camel "Hello World"
helloWorld
```

Currently supported naming conventions include `camel` (e.g. "theQuickBrownFox"), `kebab` (e.g. "the-quick-brown-fox"), `natural` (e.g. "the quick brown fox"), and `snake` (e.g. "the_quick_brown_fox").
