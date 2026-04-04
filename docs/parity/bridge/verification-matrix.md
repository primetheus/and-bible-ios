# BRIDGE-701 Verification Matrix (Android WebView Bridge -> iOS)

Date: 2026-03-16

## Scope and Method

- Contract baseline: `docs/parity/bridge/contract.md`
- Verification method:
  - direct code inspection of `BibleWebView`, `BibleBridge`, `BridgeTypes`,
    `BibleReaderController`, and `StrongsSheetView`
  - focused unit and simulator-backed regression coverage for the embedded
    My Notes and StudyPad document surfaces
- Regression evidence: `docs/parity/bridge/regression-report.md`

Use this as a map of what currently feels solid versus what still needs better
protection.

The table is meant to be read as a narrative snapshot, not just a checklist.
Some areas are already dependable, while others are still documented more
strongly than they are tested.

## Status Legend

- `Pass`: implemented and backed by direct code evidence plus current regression coverage
- `Adapted Pass`: parity is there, but iOS gets there through an intentionally different path
- `Partial`: implemented or exposed, but still not backed by enough focused evidence to treat it
  as locked

## Summary

- `Pass`: 1
- `Adapted Pass`: 1
- `Partial`: 5

## Matrix

| Bridge Contract Area | iOS Evidence | Status | Notes |
|---|---|---|---|
| Embedded My Notes and StudyPad surfaces stay connected to native persistence and document reload | `BibleBridge.swift`, `BibleReaderController.swift`; unit tests `testBookmarkServiceClearingBibleBookmarkNoteDeletesPersistedNoteRow`, `testBookmarkServiceClearingBibleBookmarkNoteRemovesBookmarkFromMyNotesQuery`; UI tests `testMyNotesDirectLaunchShowsHeaderAndReturnsToBible`, `testMyNotesSeededNoteUpdatePersistsAcrossReturnAndReopen`, `testMyNotesSeededNoteDeletePersistsAcrossReturnAndReopen`, `testBookmarkListOpensStudyPadForSelectedLabel`, `testBookmarkStudyPadCreateNoteFromLabelWorkflow` | Pass | This is the healthiest bridge-adjacent area right now: native note mutations survive the embedded document lifecycle and are still visible after reopen. |
| iOS preserves the Android-style `window.android.*` call surface and synchronous `getActiveLanguages()` behavior via an injected shim | `BibleWebView.swift` shim injection and `BibleBridge.updateActiveLanguages(_:)`; documented in `dispositions.md` | Adapted Pass | The transport path is intentionally different, but the shared frontend still boots against the Android-oriented API surface. The remaining weakness is that the regression coverage is still indirect rather than per-method. |
| Async `callId` request/response flows remain available for content expansion and native dialogs | `BibleBridge.sendResponse(...)`; `BibleReaderController` handlers for `requestMoreToBeginning`, `requestMoreToEnd`, `refChooserDialog`, and `parseRef` | Partial | The plumbing is there, but we still do not have a focused regression gate for `callId` request/response semantics. |
| Bookmark, label, and StudyPad delegate dispatch remains centralized in `BibleBridge` | `BibleBridge.userContentController(...)` bookmark and StudyPad switch branches; `BridgeTypes.swift` payload models | Partial | The dispatcher is still nicely centralized, but it is broad enough that argument-order or method-name drift could still sneak through without a dedicated suite. |
| Strong's sheet reuses the same bridge transport while depending on a dedicated `contentType: \"strongs\"` document route | `StrongsSheetView.swift` dedicated `BibleBridge`, `BibleReaderController.buildStrongsMultiDocJSON()`, `DocumentBroker.vue`, and `StrongsDocument.vue` | Partial | This one matters more now because losing `contentType: \"strongs\"` does not fail loudly; it quietly falls back to generic multi-document rendering. |
| Fullscreen, compare, help, external-link, and reference-dialog entry points remain exposed through the bridge | `BibleBridge.swift` switch branches for `toggleFullScreen`, `compare`, `helpDialog`, `openExternalLink`, and `refChooserDialog`; `BibleReaderController.swift` handlers | Partial | These branches are real and still parity-relevant, but they are not yet backed by focused bridge-domain regression coverage. |
| Swift bridge payloads remain centralized and expected to stay aligned with `bibleview-js` type expectations | `BridgeTypes.swift`; `bibleview-js/src/types/`; summarized in `bridge-guide.md` | Partial | The contract is at least explicit now, but we still lack an automated parity diff or generated-schema guard that would make this safer. |
