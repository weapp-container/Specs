# Weapp Container CocoaPods Specs

Public CocoaPods source for `WeappContainer` (iOS 16+) and `WeappContainerDesktop` (macOS 12+).

```ruby
source 'https://github.com/weapp-container/Specs.git'
source 'https://cdn.cocoapods.org/'
```

Version `0.1.0-preview.7.0` is available from this public source. Both Podspecs select immutable GitHub Release archives with SHA-256 verification. Anonymous archive download and remote `pod spec lint` passed for both Pods; iOS simulator interaction acceptance passed. Physical-device execution is not yet recorded.

```ruby
pod 'WeappContainer', '0.1.0-preview.7.0' # iOS
# Or, in a macOS target:
pod 'WeappContainerDesktop', '0.1.0-preview.7.0'
```

Specs are imported only after the matching GitHub Release archive is public and its SHA-256 is verified. The iOS ZIP retains a parent directory, so its first public Podspec explicitly flattens that directory. No published archive or version is replaced.

Trunk status: **not submitted**. The maintainer has deferred Trunk registration for this release. No Trunk upload has been attempted; use this public Specs source.

Maintainers: `node tools/import-spec.mjs --spec /absolute/WeappContainer.podspec --manifest /absolute/release.json`. The import verifies the exact version, repository, archive URL and SHA-256, downloads anonymously and refuses any existing specification. Review and lint the imported spec before merging.
