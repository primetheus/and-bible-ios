// SyncSettingsView.swift — iCloud sync settings

import SwiftUI
import BibleCore

/**
 Configures CloudKit-backed iCloud sync and surfaces current sync status.

 The view binds directly to `SyncService` state to expose the persisted enablement toggle, account
 health, restart-required state, and the last known sync timestamp. It intentionally routes
 destructive disable operations through a confirmation dialog before persisting the new preference.

 Data dependencies:
 - `SyncService` provides the effective sync mode, account description, runtime state, and last
   sync timestamp
 - localized strings provide all toggle labels, warnings, and status text

 Side effects:
 - toggling sync calls back into `SyncService` and can persist a new restart-required sync mode
 - disabling sync first presents a confirmation dialog before mutating the service state
 - the restart-required alert is presented after the user changes sync mode so the UI can explain
   that the app must restart
 */
public struct SyncSettingsView: View {
    /// Shared sync service injected from the app environment.
    @Environment(SyncService.self) private var syncService

    /// Whether the destructive disable-sync confirmation dialog is presented.
    @State private var showDisableConfirmation = false

    /// Whether the restart-required informational alert is presented.
    @State private var showRestartAlert = false

    /**
     Creates the sync settings screen with environment-provided sync state.
     */
    public init() {}

    /**
     Builds the sync toggle, status summary rows, and sync-scope explanation sections.
     */
    public var body: some View {
        Form {
            Section {
                Toggle(String(localized: "icloud_sync_enabled"), isOn: Binding(
                    get: { syncService.isEnabled },
                    set: { newValue in
                        if !newValue {
                            showDisableConfirmation = true
                        } else {
                            syncService.toggleSync()
                            showRestartAlert = true
                        }
                    }
                ))
                .disabled(syncService.requiresRestart)
                Text(String(localized: "icloud_sync_description"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text(String(localized: "icloud_sync"))
            }

            Section {
                HStack {
                    Text(String(localized: "status"))
                    Spacer()
                    statusView
                }

                if syncService.isEnabled && !syncService.requiresRestart {
                    HStack {
                        Text(String(localized: "icloud_account"))
                        Spacer()
                        Text(accountText)
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text(String(localized: "last_sync"))
                        Spacer()
                        Text(lastSyncText)
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Text(String(localized: "sync_status"))
            }

            if syncService.isEnabled && !syncService.requiresRestart {
                Section {
                    Text(String(localized: "sync_what_syncs"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } header: {
                    Text(String(localized: "sync_data_included"))
                }
            }
        }
        .navigationTitle(String(localized: "icloud_sync"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .confirmationDialog(
            String(localized: "disable_sync_title"),
            isPresented: $showDisableConfirmation,
            titleVisibility: .visible
        ) {
            Button(String(localized: "disable_sync"), role: .destructive) {
                syncService.toggleSync()
                showRestartAlert = true
            }
        } message: {
            Text(String(localized: "disable_sync_warning"))
        }
        .alert(String(localized: "restart_required"), isPresented: $showRestartAlert) {
            Button(String(localized: "ok")) {}
        } message: {
            Text(String(localized: "restart_to_apply_sync"))
        }
    }

    // MARK: - Status Display

    /**
     Builds the trailing status label for the current `SyncService` runtime state.
     */
    @ViewBuilder
    private var statusView: some View {
        switch syncService.state {
        case .disabled:
            SwiftUI.Label(String(localized: "sync_disabled"), systemImage: "icloud.slash")
                .foregroundStyle(.secondary)
        case .noAccount:
            SwiftUI.Label(String(localized: "no_icloud_account"), systemImage: "person.crop.circle.badge.xmark")
                .foregroundStyle(.red)
        case .idle:
            SwiftUI.Label(String(localized: "sync_active"), systemImage: "checkmark.icloud")
                .foregroundStyle(.green)
        case .syncing:
            SwiftUI.Label(String(localized: "syncing"), systemImage: "arrow.triangle.2.circlepath.icloud")
                .foregroundStyle(.blue)
        case .pendingRestart:
            SwiftUI.Label(String(localized: "restart_to_apply_sync"), systemImage: "arrow.clockwise.icloud")
                .foregroundStyle(.orange)
        case .error(let msg):
            SwiftUI.Label(msg, systemImage: "exclamationmark.icloud")
                .foregroundStyle(.orange)
        }
    }

    /**
     Human-readable iCloud account description shown in the status section.
     */
    private var accountText: String {
        switch syncService.state {
        case .noAccount:
            return String(localized: "no_icloud_account")
        default:
            return syncService.accountDescription ?? "—"
        }
    }

    /**
     Relative last-sync timestamp shown in the status section.

     Failure modes:
     - returns an em dash placeholder when no sync timestamp has been recorded yet
     */
    private var lastSyncText: String {
        guard let date = syncService.lastSyncDate else {
            return "—"
        }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
