# BOOKMARKS-702 Regression Report

Date: 2026-03-16

## Scope

Regression verification for the current bookmark parity surface, covering:

- native bookmark-list search, filter, sort, selection, and deletion
- label assignment and label-manager mutation flows
- StudyPad handoff and deterministic note creation
- My Notes note update and delete persistence
- note-row persistence semantics in the shared bookmark service layer

Contract reference:

- `docs/parity/bookmarks/contract.md`

Verification matrix:

- `docs/parity/bookmarks/verification-matrix.md`

## Environment

- Repository: `and-bible-ios`
- Simulator destination: `platform=iOS Simulator,name=iPhone 17`
- Validation style: focused `xcodebuild test` subset

## Tests Executed

### Unit

- `AndBibleTests/testBookmarkStoreBibleBookmarksCanFilterByLabel`
- `AndBibleTests/testBookmarkLabelSerializationSkipsDeletedBibleLabels`
- `AndBibleTests/testBookmarkServiceDeleteLabelDetachesBookmarkRelationships`
- `AndBibleTests/testBookmarkServiceClearingBibleBookmarkNoteDeletesPersistedNoteRow`
- `AndBibleTests/testBookmarkServiceClearingBibleBookmarkNoteRemovesBookmarkFromMyNotesQuery`

### UI

- `AndBibleUITests/testBookmarkSelectionNavigatesReaderToSeededReference`
- `AndBibleUITests/testBookmarkRowDeletePreservesOtherRowsAcrossReopen`
- `AndBibleUITests/testBookmarkListSortMenuReordersRows`
- `AndBibleUITests/testBookmarkListSearchNarrowsAndClearsVisibleRows`
- `AndBibleUITests/testBookmarkListLabelFilterNarrowsAndClearsVisibleRows`
- `AndBibleUITests/testLabelAssignmentTogglesFavouriteAndAssignment`
- `AndBibleUITests/testBookmarkListLabelAssignmentCreatesAndAssignsNewLabel`
- `AndBibleUITests/testBookmarkListLabelAssignmentRemovalHidesBookmarkUnderFilter`
- `AndBibleUITests/testLabelManagerCreateRenameDeleteFlow`
- `AndBibleUITests/testBookmarkStudyPadCreateNoteFromLabelWorkflow`
- `AndBibleUITests/testMyNotesSeededNoteUpdatePersistsAcrossReturnAndReopen`
- `AndBibleUITests/testMyNotesSeededNoteDeletePersistsAcrossReturnAndReopen`

## Expected Assertions Covered

### Bookmark list

- selecting a seeded bookmark navigates the reader to the bookmarked reference
- deleting one bookmark preserves the other seeded row across reopen
- changing sort order reorders the visible rows
- text search narrows and then clears back to the full seeded list
- label filtering narrows and then clears back to the full seeded list

### Labels

- toggling a label assignment and favourite state mutates the exported row state
- creating a new label from bookmark label assignment immediately assigns it
- removing the last label assignment causes the bookmark to disappear under that label filter
- label manager create, rename, and delete complete through the real CRUD flow

### StudyPad and My Notes

- opening StudyPad from a selected bookmark label supports deterministic note creation
- a seeded My Notes note can be updated, then reopened with the updated state preserved
- a seeded My Notes note can be deleted, then reopened with the deleted state preserved

### Service-layer persistence

- bookmark filtering by label works at the store layer
- deleted labels are skipped when bookmark-label JSON is serialized for the reader
- deleting a label detaches existing bookmark relationships
- clearing a bookmark note deletes the persisted note row
- clearing a bookmark note removes it from the My Notes rebuild query

## Current Result

Focused bookmark validation passed on 2026-03-16:

- unit: `5` tests, `0` failures
- UI: `12` tests, `0` failures
- UI subset runtime: about `604s` on the simulator, excluding package/bootstrap overhead before
  test execution began

This gives the bookmark domain current regression evidence for:

- bookmark-list search, filter, sort, selection, and deletion
- label assignment and label-manager CRUD
- StudyPad handoff plus deterministic note creation
- My Notes note update and delete persistence
- shared bookmark-note persistence semantics in the service layer

## Remaining Gap

The current bookmark parity gaps are:

- generic-bookmark visible workflows
- deeper StudyPad mutation coverage beyond handoff plus note creation

Those areas remain `Partial` in `verification-matrix.md` until they have focused regression
coverage.
