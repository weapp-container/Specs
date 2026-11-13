# Weapp Container CocoaPods Specs

Public CocoaPods source for `WeappContainer` (iOS 16+) and `WeappContainerDesktop` (macOS 12+).

```ruby
source 'https://github.com/weapp-container/Specs.git'
source 'https://cdn.cocoapods.org/'
```

Version `0.1.0-preview.7.1` is available from this public source. The iOS wrapper requires Xcode 27.2+ to compile (deployment target remains iOS 16+). Both Podspecs select immutable GitHub Release archives with SHA-256 values from the successful SDK publication manifests. The source SDK build, SwiftPM consumer and staged Pod lint passed; physical-device execution is not yet recorded.

```ruby
pod 'WeappContainer', '0.1.0-preview.7.1' # iOS
# Or, in a macOS target:
pod 'WeappContainerDesktop', '0.1.0-preview.7.1'
```

Specs are imported only after the matching GitHub Release archive is public and its SHA-256 is verified. The iOS ZIP retains a parent directory, so its first public Podspec explicitly flattens that directory. No published archive or version is replaced.

Trunk status: **not submitted**. The publication workflows require the owner-provided `COCOAPODS_TRUNK_TOKEN`; this public Specs source remains the available `.7.1` installation path until Trunk registration is completed.

Maintainers: `node tools/import-spec.mjs --spec /absolute/WeappContainer.podspec --manifest /absolute/release.json`. The import verifies the exact version, repository, archive URL and SHA-256, downloads anonymously and refuses any existing specification. Review and lint the imported spec before merging.
