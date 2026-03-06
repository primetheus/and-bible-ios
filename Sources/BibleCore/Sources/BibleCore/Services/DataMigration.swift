// DataMigration.swift — Store migration utilities for CloudKit dual-configuration

import Foundation

/// Handles data migration for the dual-store layout used for CloudKit sync.
///
/// The main store keeps its original name "AndBible" (→ AndBible.store) to preserve
/// existing PersistentIdentifiers. A separate "LocalStore" (→ LocalStore.store) is
/// created for device-local models (Repository, Setting).
///
/// On upgrade from single-store to dual-store:
/// - AndBible.store: continues to work unchanged (now only holds cloud-eligible models)
/// - LocalStore.store: created fresh by SwiftData. Repository and Setting start empty,
///   which is handled gracefully (repos re-seed from SWORD defaults, active workspace
///   falls through to first available).
public enum DataMigration {

    /// Repair any state left by earlier migration attempts, then ensure
    /// the canonical "AndBible.store" exists for the main configuration.
    /// Call this BEFORE creating the ModelContainer.
    public static func migrateIfNeeded() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let fm = FileManager.default

        let andBibleStore = appSupport.appendingPathComponent("AndBible.store")
        let cloudStore = appSupport.appendingPathComponent("CloudStore.store")
        let backupStore = appSupport.appendingPathComponent("AndBible.store.backup")

        // Repair scenario: an earlier build moved AndBible.store → .backup
        // and created CloudStore.store. Restore the canonical name.
        if !fm.fileExists(atPath: andBibleStore.path) {
            if fm.fileExists(atPath: cloudStore.path) {
                // CloudStore has the data — rename it back to AndBible.store
                do {
                    try fm.moveItem(at: cloudStore, to: andBibleStore)
                    // Also move WAL/SHM if present
                    for suffix in ["-shm", "-wal"] {
                        let src = appSupport.appendingPathComponent("CloudStore.store\(suffix)")
                        let dst = appSupport.appendingPathComponent("AndBible.store\(suffix)")
                        if fm.fileExists(atPath: src.path) && !fm.fileExists(atPath: dst.path) {
                            try fm.moveItem(at: src, to: dst)
                        }
                    }
                    print("[DataMigration] Restored CloudStore.store → AndBible.store")
                } catch {
                    print("[DataMigration] Failed to restore CloudStore: \(error)")
                }
            } else if fm.fileExists(atPath: backupStore.path) {
                // Only backup exists — restore it
                do {
                    try fm.moveItem(at: backupStore, to: andBibleStore)
                    print("[DataMigration] Restored AndBible.store from backup")
                } catch {
                    print("[DataMigration] Failed to restore backup: \(error)")
                }
            }
            // else: fresh install, SwiftData creates AndBible.store automatically
        }

        // Clean up stale CloudStore files (no longer used)
        for suffix in ["", "-shm", "-wal"] {
            let stale = appSupport.appendingPathComponent("CloudStore.store\(suffix)")
            if fm.fileExists(atPath: stale.path) {
                try? fm.removeItem(at: stale)
            }
        }

        // Clean up backup if canonical store is healthy
        if fm.fileExists(atPath: andBibleStore.path) && fm.fileExists(atPath: backupStore.path) {
            try? fm.removeItem(at: backupStore)
        }
    }
}
