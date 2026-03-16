# READER-703 Guardrails

## Purpose

Prevent high-risk reader regressions by making the non-negotiable ownership and
behavior rules explicit for changes in:

- `Sources/BibleUI/Sources/BibleUI/Bible/BibleReaderView.swift`
- `Sources/BibleUI/Sources/BibleUI/Bible/BibleReaderController.swift`
- `Sources/BibleUI/Sources/BibleUI/Bible/BibleWindowPane.swift`
- `Sources/BibleView/Sources/BibleView/WebViewCoordinator.swift`
- `Sources/BibleUI/Sources/BibleUI/Shared/HistoryView.swift`
- `Sources/BibleUI/Sources/BibleUI/Workspace/WorkspaceSelectorView.swift`

## Rules

1. Treat the reader shell as the owner of top-level reading workflows.

   Overflow-menu routing, history presentation, workspace selection, compare
   presentation, and fullscreen state are reader-shell responsibilities. They
   should not drift into ad hoc view-local ownership.

2. Do not break the reader handoff contract from adjacent domains.

   Search, history, bookmarks, and workspaces are only correct if they can move
   the active reader to the intended location or state. Changes that keep those
   screens working but break the reader handoff are still parity regressions.

3. Preserve persisted history semantics.

   History clear and single-row delete are persistent mutations, not temporary
   UI edits. Changes to `HistoryView` or its backing reader integration should
   keep reopen behavior intact.

4. Treat workspace selection as reader-owned state, not only a workspace-domain
   concern.

   The reader is where active workspace changes become visible. Create, rename,
   clone, and delete all need to keep the reader-shell invariants intact.

5. Fullscreen, swipe-mode, and auto-fullscreen behavior are parity-sensitive,
   even where coverage is still partial.

   These branches are easy to break through gesture or layout refactors. Thin
   current coverage is not a license to simplify them casually.

6. Reader config emission into the embedded client is contract surface.

   `buildConfigJSON()`, `updateConfig()`, and display-setting propagation are
   how reader state reaches the embedded document client. Changes there are
   bridge-affecting parity work, not isolated refactors.

7. Reader changes must update the docs in the same slice.

   When adding or changing reader contract behavior, update:

   - `docs/parity/reader/contract.md`
   - `docs/parity/reader/dispositions.md` when behavior is iOS-specific
   - `docs/parity/reader/verification-matrix.md` if status changes
   - `docs/parity/reader/regression-report.md` when validation scope changes

## Validation Expectations

At minimum, reader-adjacent changes should keep the focused workflow subset
described in `regression-report.md` green, especially:

- reader overflow-menu routing
- search-result navigation back into the reader
- history jump-back plus clear/delete persistence
- workspace selector CRUD from the reader shell

If a change touches one of the still-partial areas, raise the bar and add
focused coverage rather than relying on the existing reader subset alone.

## Current Automation Status

- The repo currently has focused reader-shell UI coverage for overflow-menu
  routing, history workflows, and workspace CRUD.
- Current protection is a combination of:
  - reader workflow tests in `AndBibleUITests`
  - explicit parity documentation in this directory
  - adjacent-domain coverage where reader handoff is part of the assertion
