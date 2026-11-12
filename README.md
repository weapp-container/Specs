# Weapp Container CocoaPods Specs

Public CocoaPods source for `WeappContainer` (iOS 16+) and `WeappContainerDesktop` (macOS 12+).

```ruby
source 'https://github.com/weapp-container/Specs.git'
source 'https://cdn.cocoapods.org/'
```

The first public version, `0.1.0-preview.7.0`, is being prepared. No Podspec has been published here yet. Specs are imported only after the matching immutable GitHub Release archive is public and its SHA-256 is verified. Source availability does not imply a completed binary publication or device acceptance.

Trunk status: **not submitted**. The release process also submits to CocoaPods Trunk while it accepts new pods. If Trunk has closed or credentials are unavailable, this record must state the exact reason; this public source remains the installation entry.

Maintainers: `node tools/import-spec.mjs --spec /absolute/WeappContainer.podspec --manifest /absolute/release.json`. The import verifies the exact version, repository, archive URL and SHA-256, downloads anonymously and refuses any existing specification. Review and lint the imported spec before merging.
