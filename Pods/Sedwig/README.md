# Sedwig
Swift API Client

This repository customizes the location of git hooks to enable tracking them in git (by default git hooks are stored in`.git/hooks` which is not tracked, so we store them in `.githooks`).

Run `git config core.hooksPath .githooks` from the root of the repository right after you clone the repository to make this work. Note this step is **mandatory**.

## Libraries

Sedwig enables networking through four sets of APIs. These APIs are individual libraries that you can use as per your requirement. These libraries are:

- CoreAPIClient: Defines primitive types such as `Request`, `Response`, etc. and vends aynschronous closure-based APIs.
- SyncAPIClient: Synchronous APIs that build on top of primitive types defined in CoreAPIClient.
- AsyncAPIClientRx: Builds on top of CoreAPIClient and vends asynchronous networking APIs using [RxSwift](https://github.com/ReactiveX/RxSwift).
- AsyncAPIClientCombine: Builds on top of CoreAPIClient and vends asynchronous networking APIs using [Combine](https://developer.apple.com/documentation/combine).

## Installation

Sedwig can be used via CocoaPods and SwiftPM.

### CocoaPods

To use all libraries in Sedwig, your Podfile should have:

`pod 'Sedwig', :git => 'https://github.com/surya-soft/Sedwig.git'`

If, instead, you want to pick between *one* or *some* of the libraries, you can do so using the instructions that follow. Note that if you aren't sure which library you should use, `SyncAPIClient`, and `AsyncAPIClientRx` are good choices.

#### CoreAPIClient

`pod 'Sedwig/CoreAPIClient', :git => 'https://github.com/surya-soft/Sedwig.git'`

#### SyncAPIClient

`pod 'Sedwig/SyncAPIClient', :git => 'https://github.com/surya-soft/Sedwig.git'`

#### AsyncAPIClientRx

`pod 'Sedwig/AsyncAPIClientRx', :git => 'https://github.com/surya-soft/Sedwig.git'`

#### AsyncAPIClientCombine

`pod 'Sedwig/AsyncAPIClientCombine', :git => 'https://github.com/surya-soft/Sedwig.git'`

Note that this library will only run on platforms that support Combine.

### SwiftPM

Using Sedwig via SwiftPM, you will end up getting all libraries. That is, you cannot pick between the libraries the way you can with CocoaPods.

Using Sedwig with SwiftPM should just work using the URL of this repository.

## Tools

### Bundler

This project uses Ruby tools for building and CI. To ensure we’re all using the same versions of these tools, we use Bundler.

To install Bundler run `gem install bundler --version 2.1.4`.

To install ruby dependencies (AKA gems) run `bundle install` from the root of the repo.

To execute Ruby commands, prefix them with `bundle exec`. For example, to run danger, run `bundle exec danger dry_run`.

To update to newer versions of gems, run `bundle update`.

### SwiftLint

This project uses [SwiftLint](https://github.com/realm/SwiftLint) to ensure that uniform coding conventions are followed.

### SwiftFormat

This project uses [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) to enforce a uniform code format.

To format code run `./bin/swiftformat .` from the root of the repo. This will result in all Swift code in the directory being formatted for you in compliance with our guidelines.

The project is set up to fail on CI if code is not formatted in compliance with SwiftFormat.

There is also a git pre-commit hook to fail the commit if it fails SwiftFormat.

To update the included swiftformat binary to the latest version of SwiftFormat, run `./update-swiftformat.sh` from the root of the repo.

### Danger

This project uses [Danger](https://github.com/danger/danger) to help catch errors. To run it locally, run `bundle exec danger dry_run` from the root of the repo.

### Package Manager

This project uses [Swift Package Manager](https://swift.org/package-manager/) to generate Xcode project, manage targets and their dependencies. To generate the project run `./create-xcodeproj.sh` in terminal from the root of the repo. 
