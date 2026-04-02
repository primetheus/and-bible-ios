# iOS Bridge Parity Dispositions

This file records the places where iOS is deliberately doing something
different while still trying to preserve the shared client contract.

## 1. iOS preserves Android-style `window.android.*` calls via an injected shim

- Status: intentional adaptation

What we do:

- iOS does not expose a literal Android `JavascriptInterface`.
- Instead, `BibleWebView` injects a `window.android` `Proxy` that forwards calls
  through `WKScriptMessageHandler`.

Why this is fine:

- The shared frontend still calls Android-style APIs directly.
- Preserving that call surface is lower risk than forking the client contract.

## 2. `getActiveLanguages()` is cached for synchronous parity

- Status: intentional adaptation

What we do:

- `getActiveLanguages()` is served from the injected
  `window.__activeLanguages__` cache on iOS.

Why this is fine:

- `WKScriptMessageHandler` does not support synchronous return values.
- The cache preserves the frontend's expectation that this call is synchronous.

## 3. Some Android bridge actions remain intentional no-ops on iOS

- Status: documented divergence

Current intentional no-ops:

- `memorize`
- `addParagraphBreakBookmark`
- `addGenericParagraphBreakBookmark`

Why this is still a gap:

- These flows do not currently have a complete native iOS implementation, so
  the bridge preserves the method surface without claiming feature parity.

## 4. Fullscreen and compare are handled through iOS-native presentation paths

- Status: intentional adaptation

What we do:

- Fullscreen toggling is driven by injected web-side double-tap handling plus
  native reader state.
- Compare presentation uses native iOS presentation paths instead of Android's
  exact UI structure.

Why this is fine:

- The user-facing behavior remains parity-oriented, but UIKit/SwiftUI
  presentation constraints differ from Android's activity/dialog model.

## 5. Strong's modal uses a dedicated embedded-client route inside a native iOS sheet

- Status: intentional adaptation

What we do:

- iOS presents the Strong's surface as a native bottom sheet owned by the
  reader shell.
- Within that sheet, the embedded client now uses the dedicated
  `contentType: "strongs"` route and `StrongsDocument` rendering path rather
  than the generic multi-document renderer.

Why this is fine:

- The richer Android-style Strong's experience depends on route-specific client
  behavior such as per-dictionary tabs and preserved in-modal state.
- iOS still needs native sheet ownership for presentation, dismissal, and
  nested reader coordination.
