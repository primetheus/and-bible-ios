# BRIDGE-702 Regression Report

Date: 2026-03-16

## Scope

This is the current validation snapshot for the bridge-adjacent surface. It
covers:

- embedded My Notes document rendering plus note mutation persistence
- StudyPad document handoff and note creation from a real bookmark workflow
- the native persistence paths that rebuild those embedded note surfaces

Contract reference:

- `docs/parity/bridge/contract.md`

Verification matrix:

- `docs/parity/bridge/verification-matrix.md`

Related domain references:

- `docs/parity/bookmarks/verification-matrix.md`
- `docs/parity/reader/verification-matrix.md`

## Environment

- Repository: `and-bible-ios`
- Simulator destination: `platform=iOS Simulator,name=iPhone 17`
- Validation style: focused `xcodebuild test` subset

## Tests Executed

### Unit

- `AndBibleTests/testBookmarkServiceClearingBibleBookmarkNoteDeletesPersistedNoteRow`
- `AndBibleTests/testBookmarkServiceClearingBibleBookmarkNoteRemovesBookmarkFromMyNotesQuery`

### UI

- `AndBibleUITests/testMyNotesDirectLaunchShowsHeaderAndReturnsToBible`
- `AndBibleUITests/testMyNotesSeededNoteUpdatePersistsAcrossReturnAndReopen`
- `AndBibleUITests/testMyNotesSeededNoteDeletePersistsAcrossReturnAndReopen`
- `AndBibleUITests/testBookmarkListOpensStudyPadForSelectedLabel`
- `AndBibleUITests/testBookmarkStudyPadCreateNoteFromLabelWorkflow`

## What This Validation Actually Covers

### Embedded note surfaces

- the embedded My Notes surface opens, returns to the reader shell, and survives reopen
- updating a seeded My Notes note persists through return and reopen
- deleting a seeded My Notes note persists through return and reopen

### StudyPad handoff

- a real bookmark-list label flow can hand off into the matching StudyPad document
- the reader-shell StudyPad note workflow can create one deterministic note and expose the
  resulting persisted state

### Persistence support

- clearing a bookmark note deletes the persisted note row
- rebuilding the My Notes bookmark query after note deletion removes the bookmark from the
  resulting note-backed surface

## Current Result

Focused bridge-adjacent validation passed on 2026-03-16:

- Unit: `2` tests, `0` failures
- Unit runtime: `0.291s`
- UI: `5` tests, `0` failures
- UI runtime: `161.543s`

Taken together, this gives the bridge domain current regression evidence for:

- embedded My Notes document lifecycle and note persistence
- StudyPad document handoff plus note creation
- bookmark-note persistence feeding those embedded surfaces

So the bridge story is not "everything is shaky." It is more specific than
that: the note-backed embedded surfaces are in decent shape, while the rawer
transport edges still need more direct protection.

## What Is Still Not Well Locked Yet

The note-backed document surfaces are in decent shape. The pieces that still
need tighter protection are:

- raw `window.android.*` compatibility-shim behavior on a per-method basis
- `callId` async request/response flows for content expansion and native dialogs
- Strong's sheet bridge coverage, especially the dedicated `contentType: "strongs"` route
- fullscreen, compare, help, and reference-dialog bridge workflows
- explicit payload-shape guardrails between `BridgeTypes.swift` and `bibleview-js/src/types/`

Those areas are implemented and documented, but they are not yet locked by
focused bridge-domain regression coverage, so they still show up as `Partial`
in [verification-matrix.md](verification-matrix.md).
