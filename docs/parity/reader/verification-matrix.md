# READER-701 Verification Matrix (Android Reader -> iOS)

Date: 2026-03-16

## Scope and Method

- Contract baseline: `docs/parity/reader/contract.md`
- Verification method:
  - direct code inspection of `BibleReaderView`, `BibleReaderController`, `BibleWindowPane`,
    `HistoryView`, `WorkspaceSelectorView`, and `WebViewCoordinator`
  - focused simulator-backed UI coverage from `AndBibleUITests`
- Regression evidence: `docs/parity/reader/regression-report.md`

## Status Legend

- `Pass`: implemented and backed by direct code evidence plus current regression coverage
- `Adapted Pass`: parity delivered with explicit iOS implementation differences documented in
  `dispositions.md`
- `Partial`: implemented or exposed, but not yet backed by enough focused evidence to treat the
  area as locked

## Summary

- `Pass`: 4
- `Adapted Pass`: 0
- `Partial`: 4

## Matrix

| Reader Contract Area | iOS Evidence | Status | Notes |
|---|---|---|---|
| Reader overflow menu opens core reader-owned destinations | `BibleReaderView.swift`; UI tests `testDownloadsScreenOpensFromReaderMenu`, `testBookmarksScreenOpensFromReaderMenu`, `testAboutScreenOpensFromReaderMenu` | Pass | The top-level reader shell is regression-gated for the primary menu destinations that still depend on the active reader surface. |
| Search result selection returns control to the reader and moves the active reference | `BibleReaderView.swift`, `BibleReaderController.swift`; UI test `testSearchResultSelectionNavigatesReaderToBundledReference` | Pass | The reader side of search integration is locked here; search query semantics remain documented under `docs/parity/search/`. |
| History jump-back plus destructive clear/delete flows persist through reopen | `HistoryView.swift`, `BibleReaderView.swift`, `BibleReaderController.swift`; UI tests `testHistorySelectionNavigatesReaderToSeededReference`, `testHistoryClearRemovesSeededRowAcrossReopen`, `testHistoryRowDeletePreservesOtherRowsAcrossReopen` | Pass | This protects both navigation back into the reader and persisted destructive history mutations. |
| Workspace selection and CRUD remain coordinated by the reader shell | `BibleReaderView.swift`, `WorkspaceSelectorView.swift`, `WindowManager`; UI test `testWorkspaceSelectorCreateRenameCloneDeleteFlow` | Pass | The current gate covers the reader-owned workspace selector flow rather than only lower-level persistence. |
| Horizontal swipe modes and auto-fullscreen thresholds are implemented natively | `WebViewCoordinator.swift` native swipe/scroll callbacks; `BibleReaderView.handleNativeHorizontalSwipe(_:)` and auto-fullscreen tracking in `BibleReaderView` | Partial | The parity-sensitive code paths exist, but there is no focused regression gate yet for swipe-mode or auto-fullscreen behavior. |
| Double-tap fullscreen remains owned by the native reader shell | `BibleReaderController.handleToggleFullscreen()` and `BibleReaderView` fullscreen state/overlay ownership; documented in `dispositions.md` | Partial | The platform adaptation is explicit, but the double-tap fullscreen branch is not yet covered by focused regression. |
| Compare requests are presented through native iOS sheet flow | `BibleReaderController.compareSelection()`, `BibleReaderController.bridge(_:compareVerses:startOrdinal:endOrdinal:)`, `BibleReaderView.showCompare`, `presentCompareView(...)`; documented in `dispositions.md` | Partial | The reader still owns the compare entry points, but there is no focused workflow gate for compare presentation yet. |
| Reader config pushes active-window and display state into the embedded client | `BibleReaderController.buildConfigJSON()`, `BibleReaderController.updateConfig()`, `BibleReaderView.updateDisplaySettings(...)` | Partial | The Android-parity config bridge is central to runtime behavior, but it is not yet locked by a focused regression report in this domain. |
