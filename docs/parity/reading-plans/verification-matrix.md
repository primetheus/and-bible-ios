# READING-PLANS-701 Verification Matrix (Android Reading Plans -> iOS)

Date: 2026-03-16

## Scope and Method

- Contract baseline: `docs/parity/reading-plans/contract.md`
- Verification method:
  - direct code inspection of `ReadingPlanService`, `ReadingPlanListView`, `DailyReadingView`,
    and the reading-plan remote sync services
  - focused simulator-backed UI coverage from `AndBibleUITests`
  - focused unit and integration coverage from `AndBibleTests`
- Regression evidence: `docs/parity/reading-plans/regression-report.md`

## Status Legend

- `Pass`: implemented and backed by direct code evidence plus current regression coverage
- `Adapted Pass`: parity delivered with explicit iOS implementation differences documented in
  `dispositions.md`
- `Partial`: implemented or exposed, but not yet backed by enough focused evidence to treat the
  area as locked

## Summary

- `Pass`: 5
- `Adapted Pass`: 1
- `Partial`: 3

## Matrix

| Reading Plan Contract Area | iOS Evidence | Status | Notes |
|---|---|---|---|
| Android `.properties` template parsing and custom-plan import syntax | `ReadingPlanService.parseProperties(_:)`, `ReadingPlanService.importCustomPlan(name:propertiesText:)` | Partial | The parser preserves Android-style `dayNumber=OsisRef...` semantics and ignores non-numeric keys, but custom import is not yet locked by focused regression coverage. |
| Persisted plan creation keeps `currentDay` separate from 1-based day rows | `ReadingPlanService.startPlan(...)`, `DailyReadingView.loadPlan()`, `dispositions.md`; unit tests assert persisted `currentDay` values during restore/apply/upload flows | Adapted Pass | iOS intentionally keeps `ReadingPlan.currentDay` zero-based while generated `ReadingPlanDay.dayNumber` rows remain 1-based. |
| Reading-plan list groups active vs completed plans and exposes start, delete, and import affordances | `ReadingPlanListView.swift`, `AvailablePlansView` | Partial | The list surface is implemented, but current focused UI coverage starts from a seeded daily-reading route rather than the list/start flow. |
| Daily-reading progression marks a day complete and advances to the next day | `DailyReadingView.markDayComplete(_:)`, `DailyReadingView.checkPlanCompletion()`, UI test `testReadingPlansStartPlanAndAdvanceDay` | Pass | The current UI gate verifies day `1 -> 2` advancement on a seeded active plan. |
| Android initial-backup restore reads staged `readingplans.sqlite3` snapshots and preserves raw status payloads | `RemoteSyncReadingPlanRestoreService`, `RemoteSyncReadingPlanStatusStore`; unit tests `testRemoteSyncReadingPlanRestoreReadsAndroidSnapshot` and `testRemoteSyncReadingPlanRestoreReplacesLocalPlansAndPreservesAndroidStatuses` | Pass | This locks the initial Android import contract plus raw-status fidelity preservation. |
| Restore validation rejects unsupported plan definitions, orphan statuses, and malformed status JSON without mutation | `RemoteSyncReadingPlanRestoreService.preparePlans(from:)`; unit tests `testRemoteSyncReadingPlanRestoreRejectsUnknownPlanDefinitionsWithoutMutation`, `testRemoteSyncReadingPlanRestoreRejectsOrphanStatusesWithoutMutation`, `testRemoteSyncReadingPlanRestoreRejectsMalformedStatusPayloads` | Pass | Validation remains all-or-nothing before local reading-plan state is replaced. |
| Initial-backup upload writes a full Android-shaped database and records patch-zero baseline state | `RemoteSyncInitialBackupUploadService.buildReadingPlanInitialBackup(...)`; unit test `testRemoteSyncInitialBackupUploadWritesReadingPlanDatabaseAndResetsBaseline` | Pass | This protects the create-new remote bootstrap path for reading plans. |
| Sparse patch replay, sparse patch upload, and steady-state synchronization preserve reading-plan progress | `RemoteSyncReadingPlanPatchApplyService`, `RemoteSyncReadingPlanPatchUploadService`, `RemoteSyncSynchronizationService`; unit tests `testRemoteSyncReadingPlanPatchApplyReplaysNewerRowsAndRecordsPatchStatus`, `testRemoteSyncReadingPlanPatchApplyDeletesStatusesByRemoteIdentifier`, `testRemoteSyncReadingPlanPatchApplySkipsOlderRows`, `testRemoteSyncReadingPlanPatchUploadWritesAndUploadsSparsePatch`, `testRemoteSyncReadingPlanPatchUploadDetectsDeleteAfterInitialRestoreRefresh`, `testRemoteSyncSynchronizationServiceSynchronizesReadyReadingPlanCategory`, `testRemoteSyncSynchronizationServiceUploadsLocalReadingPlanChangesWhenNoRemotePatchesExist` | Pass | Both inbound replay and outbound upload are regression-gated for the current Android-compatible sync contract. |
| iOS-specific algorithmic plans remain additive extensions, not replacements for Android bundled plans | `ReadingPlanService.availablePlans`, `ReadingPlanService.ntIn90Days`, `ReadingPlanService.psalmsProverbs`, `dispositions.md` | Partial | The extension is explicit and documented, but there is no focused regression gate for algorithmic-plan lifecycle behavior yet. |
