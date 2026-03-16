# READER-702 Regression Report

Date: 2026-03-16

## Scope

Regression verification for the current reader parity surface, covering:

- reader overflow-menu entry points
- reader integration with search result selection
- history jump-back, clear, and single-row delete flows
- workspace selector CRUD from the reader shell

Contract reference:

- `docs/parity/reader/contract.md`

Verification matrix:

- `docs/parity/reader/verification-matrix.md`

Related domain references:

- `docs/parity/search/verification-matrix.md`
- `docs/parity/bookmarks/verification-matrix.md`
- `docs/parity/settings/verification-matrix.md`

## Environment

- Repository: `and-bible-ios`
- Simulator destination: `platform=iOS Simulator,name=iPhone 17`
- Validation style: focused `xcodebuild test` subset

## Tests Executed

### UI

- `AndBibleUITests/testDownloadsScreenOpensFromReaderMenu`
- `AndBibleUITests/testBookmarksScreenOpensFromReaderMenu`
- `AndBibleUITests/testAboutScreenOpensFromReaderMenu`
- `AndBibleUITests/testSearchResultSelectionNavigatesReaderToBundledReference`
- `AndBibleUITests/testHistorySelectionNavigatesReaderToSeededReference`
- `AndBibleUITests/testHistoryClearRemovesSeededRowAcrossReopen`
- `AndBibleUITests/testHistoryRowDeletePreservesOtherRowsAcrossReopen`
- `AndBibleUITests/testWorkspaceSelectorCreateRenameCloneDeleteFlow`

## Expected Assertions Covered

### Reader menu and shell ownership

- the real reader overflow menu still opens core destinations such as Downloads, Bookmarks, and About
- search result selection returns the app to a new reader reference, not only a search-side state change

### History

- selecting a prior history row moves the active reader from its seeded `Genesis 1` location
- clearing history removes persisted rows across reopen
- deleting one history row preserves the other persisted rows across reopen

### Workspaces

- workspace creation, rename, clone, and delete remain driven through the reader-owned workspace selector

## Current Result

Focused reader validation passed on 2026-03-16:

- UI: `8` tests, `0` failures
- Runtime: `339.194s`

This gives the reader domain current regression evidence for:

- reader overflow-menu entry points
- search-to-reader navigation handoff
- history navigation and destructive persistence
- workspace selector CRUD

## Remaining Gap

The current reader parity gap is not the shell-navigation baseline. It is:

- swipe-mode and auto-fullscreen behavior
- double-tap fullscreen behavior
- compare presentation workflows
- explicit regression around the config payload pushed into the embedded document client

Those branches are implemented and documented, but they are not yet locked by focused reader-domain
regression coverage, so they remain `Partial` in `verification-matrix.md`.
