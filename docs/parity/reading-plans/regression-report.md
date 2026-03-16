# READING-PLANS-702 Regression Report

Date: 2026-03-16

## Scope

Regression verification for the current reading-plan parity surface, covering:

- daily-reading progression in the native SwiftUI screen
- Android initial-backup snapshot reading and validation
- raw Android status-payload preservation
- Android-shaped initial-backup upload
- sparse patch replay and sparse patch upload
- steady-state remote synchronization of reading-plan changes

Contract reference:

- `docs/parity/reading-plans/contract.md`

Verification matrix:

- `docs/parity/reading-plans/verification-matrix.md`

## Environment

- Repository: `and-bible-ios`
- Simulator destination: `platform=iOS Simulator,name=iPhone 17`
- Validation style: focused `xcodebuild test` subset

## Tests Executed

### Unit and Integration

- `AndBibleTests/testRemoteSyncReadingPlanRestoreReadsAndroidSnapshot`
- `AndBibleTests/testRemoteSyncReadingPlanRestoreReplacesLocalPlansAndPreservesAndroidStatuses`
- `AndBibleTests/testRemoteSyncReadingPlanRestoreRejectsUnknownPlanDefinitionsWithoutMutation`
- `AndBibleTests/testRemoteSyncReadingPlanRestoreRejectsOrphanStatusesWithoutMutation`
- `AndBibleTests/testRemoteSyncReadingPlanRestoreRejectsMalformedStatusPayloads`
- `AndBibleTests/testRemoteSyncReadingPlanPatchApplyReplaysNewerRowsAndRecordsPatchStatus`
- `AndBibleTests/testRemoteSyncReadingPlanPatchApplyDeletesStatusesByRemoteIdentifier`
- `AndBibleTests/testRemoteSyncReadingPlanPatchApplySkipsOlderRows`
- `AndBibleTests/testRemoteSyncInitialBackupUploadWritesReadingPlanDatabaseAndResetsBaseline`
- `AndBibleTests/testRemoteSyncSynchronizationServiceSynchronizesReadyReadingPlanCategory`
- `AndBibleTests/testRemoteSyncSynchronizationServiceUploadsLocalReadingPlanChangesWhenNoRemotePatchesExist`
- `AndBibleTests/testRemoteSyncReadingPlanPatchUploadReturnsNilWhenStateMatchesBaseline`
- `AndBibleTests/testRemoteSyncReadingPlanPatchUploadWritesAndUploadsSparsePatch`
- `AndBibleTests/testRemoteSyncReadingPlanPatchUploadDetectsDeleteAfterInitialRestoreRefresh`

### UI

- `AndBibleUITests/testReadingPlansStartPlanAndAdvanceDay`

## Expected Assertions Covered

### Daily-reading progression

- a seeded active plan opens directly into `DailyReadingView`
- the current-day label starts on day `1`
- tapping `Mark as Read` advances the visible day to `2`

### Android initial-backup restore

- staged Android `readingplans.sqlite3` snapshots can be read successfully
- iOS rebuilds supported plans from bundled templates while preserving raw Android status payloads
- unsupported plan codes, orphan statuses, and malformed status JSON fail before mutation

### Android-shaped outbound sync

- initial-backup upload writes a full Android-shaped reading-plan database
- patch-zero bookkeeping is recorded after successful upload
- sparse patch upload stays idle when the local state matches the accepted baseline
- sparse patch upload emits only changed or deleted rows when the local state diverges

### Steady-state synchronization

- newer remote reading-plan patches replay into local SwiftData state
- remote delete patches remove preserved status rows correctly
- older patches are skipped
- a ready reading-plan category can both replay remote patches and upload local changes

## Current Result

Focused reading-plan validation passed on 2026-03-16:

- unit and integration: `14` tests, `0` failures
- UI: `1` test, `0` failures
- combined focused subset runtime: about `53s` end-to-end

This gives the reading-plan domain current regression evidence for:

- Android initial-backup restore
- all-or-nothing snapshot validation
- daily-reading advancement
- Android-shaped initial-backup upload
- sparse patch replay
- sparse patch upload
- steady-state synchronization

## Remaining Gap

The current reading-plan parity gap is not the sync core. It is:

- list/start/delete/import behavior from the real `ReadingPlanListView`
- regression coverage for the additive iOS algorithmic plans
- a focused import regression for custom `.properties` plans

Those areas are implemented, but they are not yet locked by focused regression
coverage, so they remain `Partial` in `verification-matrix.md`.
