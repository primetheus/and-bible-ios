# BOOKMARKS-701 Verification Matrix (Android Bookmarks -> iOS)

Date: 2026-03-16

## Scope and Method

- Contract baseline: `docs/parity/bookmarks/contract.md`
- Verification method:
  - direct code inspection of `BookmarkService`, `BookmarkListView`, `LabelAssignmentView`,
    `LabelManagerView`, and the reader-side bookmark document hooks
  - focused simulator-backed UI coverage from `AndBibleUITests`
  - focused unit regression coverage from `AndBibleTests`
- Regression evidence: `docs/parity/bookmarks/regression-report.md`

## Status Legend

- `Pass`: implemented and backed by direct code evidence plus current regression coverage
- `Adapted Pass`: parity delivered with explicit iOS implementation differences documented in
  `dispositions.md`
- `Partial`: implemented or exposed, but not yet backed by enough focused evidence to treat the
  area as locked

## Summary

- `Pass`: 5
- `Adapted Pass`: 2
- `Partial`: 2

## Matrix

| Bookmark Contract Area | iOS Evidence | Status | Notes |
|---|---|---|---|
| Bookmark list browsing: search, label filter, sort, row navigation, and row deletion | `BookmarkListView.swift`; UI tests `testBookmarkSelectionNavigatesReaderToSeededReference`, `testBookmarkRowDeletePreservesOtherRowsAcrossReopen`, `testBookmarkListSortMenuReordersRows`, `testBookmarkListSearchNarrowsAndClearsVisibleRows`, `testBookmarkListLabelFilterNarrowsAndClearsVisibleRows` | Pass | The native list surface is regression-gated as a real reader-owned workflow, not only by direct launch. |
| Label assignment: toggle assignment, toggle favourite, create label inline, remove label | `LabelAssignmentView.swift`; UI tests `testLabelAssignmentTogglesFavouriteAndAssignment`, `testBookmarkListLabelAssignmentCreatesAndAssignsNewLabel`, `testBookmarkListLabelAssignmentRemovalHidesBookmarkUnderFilter` | Pass | Covers both relationship mutation and immediate UI reflection back in the bookmark list. |
| Label manager CRUD | `LabelManagerView.swift`; UI test `testLabelManagerCreateRenameDeleteFlow` | Pass | Create, rename, and delete are locked by a real end-to-end UI workflow. |
| StudyPad handoff from bookmarks plus new note creation | `BookmarkListView.swift`, `BibleReaderController.swift`, `BibleReaderView.swift`; UI test `testBookmarkStudyPadCreateNoteFromLabelWorkflow` | Pass | The current evidence covers opening StudyPad from a selected label and creating one deterministic note. |
| My Notes note mutation and delete persistence | `BibleReaderController.swift`, `BibleReaderView.swift`; UI tests `testMyNotesSeededNoteUpdatePersistsAcrossReturnAndReopen`, `testMyNotesSeededNoteDeletePersistsAcrossReturnAndReopen` | Pass | This locks the user-visible note update/delete contract across return and reopen. |
| Bookmark note persistence split across bookmark rows and separate note entities | `BookmarkService.saveBibleBookmarkNote`, `BookmarkStore`; unit tests `testBookmarkServiceClearingBibleBookmarkNoteDeletesPersistedNoteRow`, `testBookmarkServiceClearingBibleBookmarkNoteRemovesBookmarkFromMyNotesQuery` | Adapted Pass | iOS preserves the Android-compatible data split, but exposes note-centric workflows through a separate My Notes surface. |
| Native bookmark list plus separate My Notes surface instead of one unified browser | `BookmarkListView.swift` note suppression and `BibleReaderController` My Notes document flow; documented in `dispositions.md`; UI coverage spans both surfaces | Adapted Pass | The parity goal is shared data semantics and user-visible outcomes, not Android-identical screen structure. |
| StudyPad ordering, reorder, and delete breadth | `BookmarkService` and `BibleReaderController` StudyPad entry operations exist; no focused regression currently covers reorder or delete | Partial | Current evidence only locks handoff plus note creation, not the full StudyPad mutation surface. |
| Generic bookmark visible workflow parity | `BookmarkService` and models support generic bookmarks; no focused regression currently exercises generic-bookmark browsing, editing, or label assignment from a visible UI path | Partial | The generic side of the bookmark domain exists in persistence and bridge logic, but it is not yet gated by focused workflow coverage. |
