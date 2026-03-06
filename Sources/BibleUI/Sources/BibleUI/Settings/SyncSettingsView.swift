// SyncSettingsView.swift — iCloud sync settings

import SwiftUI
import BibleCore

/// Settings view for iCloud CloudKit sync configuration.
public struct SyncSettingsView: View {
    @Environment(SyncService.self) private var syncService

    @State private var showDisableConfirmation = false
    @State private var showRestartAlert = false

    public init() {}

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

    private var accountText: String {
        switch syncService.state {
        case .noAccount:
            return String(localized: "no_icloud_account")
        default:
            return syncService.accountDescription ?? "—"
        }
    }

    private var lastSyncText: String {
        guard let date = syncService.lastSyncDate else {
            return "—"
        }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
