// RemoteSyncInitialBackupRestoreService.swift — Category-level initial-backup restore dispatch

import Foundation
import SwiftData

/**
 Errors emitted while restoring a staged remote initial backup into live local data.

 The dispatcher currently supports reading-plan backups only. Bookmark and workspace restores are
 intentionally rejected until their schema mapping and fidelity-preservation rules are implemented.
 */
public enum RemoteSyncInitialBackupRestoreError: Error, Equatable {
    /// The requested sync category does not yet have an implemented initial-backup restore path.
    case unsupportedCategory(RemoteSyncCategory)
}

/**
 Summary payload returned after a staged initial backup is restored.

 The enum preserves category-specific report shapes without erasing the details needed by higher
 layers for telemetry, logging, or later UI.
 */
public enum RemoteSyncInitialBackupRestoreReport: Sendable, Equatable {
    /// Successful restore report for the reading-plan sync category.
    case readingPlans(RemoteSyncReadingPlanRestoreReport)
}

/**
 Restores staged remote initial backups into local SwiftData using category-specific services.

 Android sync treats bookmarks, workspaces, and reading plans as separate SQLite databases with
 different schemas. This dispatcher preserves that boundary on iOS: it selects the correct
 category restore implementation for a staged backup instead of forcing unrelated categories
 through one generic SQLite importer.

 Data dependencies:
 - `RemoteSyncReadingPlanRestoreService` restores staged Android `readingplans.sqlite3` backups
 - `SettingsStore` provides local-only persistence for fidelity-preserving side stores such as
   `RemoteSyncReadingPlanStatusStore`

 Side effects:
 - mutates live local SwiftData records for the supported category
 - may write local-only settings rows needed to preserve Android-only fidelity

 Failure modes:
 - throws `RemoteSyncInitialBackupRestoreError.unsupportedCategory` for categories whose restore
   mapping has not been implemented yet
 - rethrows category-specific restore errors from the selected restore service

 Concurrency:
 - this type inherits the confinement rules of the supplied `ModelContext` and `SettingsStore`
 */
public final class RemoteSyncInitialBackupRestoreService {
    private let readingPlanRestoreService: RemoteSyncReadingPlanRestoreService

    /**
     Creates a category-level initial-backup restore dispatcher.

     - Parameter readingPlanRestoreService: Restore service used for the reading-plan category.
     - Side effects: none.
     - Failure modes: This initializer cannot fail.
     */
    public init(
        readingPlanRestoreService: RemoteSyncReadingPlanRestoreService = RemoteSyncReadingPlanRestoreService()
    ) {
        self.readingPlanRestoreService = readingPlanRestoreService
    }

    /**
     Restores one staged initial backup into the local store for the requested sync category.

     - Parameters:
       - stagedBackup: Previously downloaded and extracted initial-backup database.
       - category: Logical sync category that owns the staged backup.
       - modelContext: SwiftData context whose live category records should be replaced.
       - settingsStore: Local-only settings store used by category-specific fidelity helpers.
     - Returns: Category-specific restore summary describing the applied restore.
     - Side effects:
       - mutates live SwiftData state for the supported category
       - may persist local-only helper state needed to preserve Android-only fidelity
     - Failure modes:
       - throws `RemoteSyncInitialBackupRestoreError.unsupportedCategory` for categories without an
         implemented restore path
       - rethrows category-specific snapshot and restore errors from the selected service
     */
    public func restoreInitialBackup(
        _ stagedBackup: RemoteSyncStagedInitialBackup,
        category: RemoteSyncCategory,
        modelContext: ModelContext,
        settingsStore: SettingsStore
    ) throws -> RemoteSyncInitialBackupRestoreReport {
        switch category {
        case .readingPlans:
            let snapshot = try readingPlanRestoreService.readSnapshot(from: stagedBackup.databaseFileURL)
            let statusStore = RemoteSyncReadingPlanStatusStore(settingsStore: settingsStore)
            let report = try readingPlanRestoreService.replaceLocalReadingPlans(
                from: snapshot,
                modelContext: modelContext,
                statusStore: statusStore
            )
            return .readingPlans(report)
        case .bookmarks, .workspaces:
            throw RemoteSyncInitialBackupRestoreError.unsupportedCategory(category)
        }
    }
}
