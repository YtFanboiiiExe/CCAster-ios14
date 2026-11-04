![CCAster](assets/banner.png)

# CCAster

CCAster is an iOS 18-inspired, editable Control Center experience for rootful iOS 14 (port of the original rootless iOS 16 tweak).

The project currently focuses on SpringBoard-side Control Center behavior:

- editable module layout
- CCAster's custom add-control sheet
- paged module placement
- resize chrome and custom module footprints
- iOS 14 compatibility around `ControlCenterUIKit` and `ControlCenterServices`

This source repository is intentionally separate from the public package feed. Pushing here does not publish a package to the live APT repo or GitHub Pages.

## Building

CCAster is a rootful Theos project (iOS 14 SDK, `iphoneos-arm`).

```sh
env CLANG_MODULE_CACHE_PATH=/tmp/clang-module-cache SWIFT_MODULE_CACHE_PATH=/tmp/swift-module-cache make clean package FINALPACKAGE=1
```

The package is configured for iOS 14:

- package id: `com.futur3sn0w.ccaster`
- firmware: `>= 14.0, << 15.0`
- injection target: SpringBoard
- dependencies: MobileSubstrate (or a compatible injector such as libhooker/Substitute) and PreferenceLoader

## Project Layout

- `Tweak.xm` contains the SpringBoard hooks, layout engine, edit mode, add sheet, and module presentation logic.
- `prefs/` contains the PreferenceLoader bundle.
- `scripts/` contains local device/testing helpers.

Generated build output, package artifacts, screenshots, and diagnostics are intentionally ignored by git.

## COSMIC Kit

CCAster can work with [COSMIC Kit](https://github.com/MoarTweaks/COSMICKit), a companion package for optional Control Center modules.

The split is intentional:

- CCAster owns the Control Center experience: layout, editing, add sheet, paging, resize behavior, and runtime integration.
- COSMIC Kit owns optional module bundles that can be installed independently from the CCAster core.

The first COSMIC Kit split moved the extra connectivity module bundles out of the CCAster package while preserving their existing bundle identifiers. This keeps current CCAster runtime handling and saved layouts stable while giving future modules a cleaner home.

Future work can make the CCAster add sheet COSMIC-aware, including support for module families, duplicate-capable modules, and dynamically generated module instances with unique Apple-facing identifiers.

## iOS 14 port notes

Known differences from the iOS 16 build:

- iOS 15+/16+ APIs (`UIButtonConfiguration`, `UISheetPresentationController`, hierarchical symbol colour, variable-value symbols) are resolved at runtime or replaced with iOS 14 equivalents.
- The Now Playing restyling hooks target `MRU*` classes. As far as I know these do not exist on iOS 14 (it uses `MediaControlsUI`), so those hooks are inert and the media module keeps its stock look.
- This port has not been compiled or run on a device by the porter. Layout, module-catalog and expanded-module behavior depend on private Control Center internals that need on-device verification on iOS 14.
