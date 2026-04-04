# iOS Reader Parity Dispositions

This file records the places where iOS is deliberately taking a different path
to get to a similar result.

## 1. Reader shell routing uses a native drawer plus a custom anchored overflow popup

- Status: intentional adaptation

What we do:

- iOS now mirrors Android's shell split with a left navigation drawer for
  primary destinations and a right overflow popup for reader-local toggles and
  options.
- The shell uses native SwiftUI/UIKit presentation and packaged Android-style
  assets rather than Android's original view classes.

Why this is fine:

- The parity goal is the resulting menu structure, ordering, and affordance
  semantics, not a literal port of Android widget plumbing.

## 2. Swipe navigation is implemented with native gestures, not Android view plumbing

- Status: intentional adaptation

What we do:

- iOS maps `bible_view_swipe_mode` onto native gesture recognizers and WebView
  scrolling behavior rather than Android's exact view stack.

Why this is fine:

- The parity goal is the resulting chapter/page/none behavior, not identical UI
  implementation.

## 3. Compare presentation uses native iOS sheet presentation

- Status: intentional adaptation

What we do:

- Bridge-driven compare requests are presented through UIKit/SwiftUI sheet
  presentation rather than Android's exact activity/dialog structure.

Why this is fine:

- The compare action must integrate with iOS presentation state and the
  top-most visible controller.

## 4. Reader fullscreen is coordinated by native shell state

- Status: intentional adaptation

What we do:

- Web content can request fullscreen toggles, but the actual fullscreen state is
  owned by the native reader shell.

Why this is fine:

- On iOS, hiding chrome, overlays, and bars is coordinated above the WebView,
  not inside the client bundle alone.

## 5. Strong's modal presentation is native, while Strong's content routing is embedded-client driven

- Status: intentional adaptation

What we do:

- iOS presents the Strong's / dictionary surface as a native bottom sheet.
- Inside that sheet, iOS now routes Strong's content through the dedicated
  `StrongsDocument` client path with tabbed per-dictionary rendering, rather
  than relying on generic multi-document rendering.

Why this is fine:

- The parity goal is the richer Android-style Strong's experience, while still
  respecting iOS-native sheet ownership and presentation state.

## 6. Some parity-sensitive reader inputs remain constrained by platform limits

- Status: documented constraint

What we do:

- Hardware volume-key scrolling does not exist as a functional reader feature on
  iOS even though the setting is preserved for parity and sync continuity.

Why this still remains a gap:

- iOS does not expose app-level interception of hardware volume buttons for this
  type of custom reader action.
