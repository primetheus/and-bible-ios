// AndBibleApp.swift — Main app entry point

import SwiftUI
import SwiftData
import BibleCore
import BibleUI
import SwordKit
#if os(iOS)
import UIKit
#endif

/// AndBible iOS — Powerful offline Bible study app.
///
/// Universal SwiftUI app for iPhone, iPad, and Mac.
@main
struct AndBibleApp: App {
    /// SwiftData model container for all persisted entities.
    let modelContainer: ModelContainer

    /// Core services shared across the app.
    @State private var windowManager: WindowManager
    private let speakService = SpeakService()
    @State private var syncService: SyncService
    @State private var searchIndexService = SearchIndexService()

    @Environment(\.scenePhase) private var scenePhase

    /// Discrete mode persists across launches — controls icon switching.
    @AppStorage("discrete_mode") private var isDiscreteMode = false
    /// When enabled, calculator gate appears on every app launch/resume.
    @AppStorage("show_calculator") private var showCalculator = false
    /// Temporary unlock for the current session — does NOT change the persisted setting.
    @State private var isUnlocked = false

    /// UserDefaults key for the iCloud sync toggle.
    /// Read from UserDefaults (not SwiftData) because we need it before the container is created.
    static let iCloudSyncEnabledKey = "icloud_sync_enabled"

    init() {
        // Repair any stale migration state before creating the ModelContainer
        DataMigration.migrateIfNeeded()

        // Read iCloud sync preference from UserDefaults (before container creation)
        let iCloudEnabled = UserDefaults.standard.bool(forKey: Self.iCloudSyncEnabledKey)

        // -- User data models: keep config name "AndBible" so existing store file is reused.
        // When iCloud sync is enabled, these models sync via CloudKit. --
        let cloudModels: [any PersistentModel.Type] = [
            Workspace.self,
            Window.self,
            PageManager.self,
            HistoryItem.self,
            BibleBookmark.self,
            BibleBookmarkNotes.self,
            BibleBookmarkToLabel.self,
            GenericBookmark.self,
            GenericBookmarkNotes.self,
            GenericBookmarkToLabel.self,
            Label.self,
            StudyPadTextEntry.self,
            StudyPadTextEntryText.self,
            ReadingPlan.self,
            ReadingPlanDay.self,
        ]

        // -- Device-local models: never sync, separate store. --
        let localModels: [any PersistentModel.Type] = [
            Repository.self,
            Setting.self,
        ]

        let allModels = cloudModels + localModels
        let schema = Schema(allModels)

        // Keep the original config name "AndBible" so SwiftData reuses the existing
        // "AndBible.store" file. Changing the name would break PersistentIdentifiers.
        let cloudConfig = ModelConfiguration(
            "AndBible",
            schema: Schema(cloudModels),
            isStoredInMemoryOnly: false,
            cloudKitDatabase: iCloudEnabled ? .private("iCloud.org.andbible.ios") : .none
        )

        let localConfig = ModelConfiguration(
            "LocalStore",
            schema: Schema(localModels),
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .none
        )

        // Set up SWORD module directory before creating any SwordManager
        SwordSetup.ensureModulesReady()

        // Initialize SyncService with current toggle state
        let sync = SyncService()
        sync.setInitialState(enabled: iCloudEnabled)
        self._syncService = State(initialValue: sync)

        do {
            let container = try ModelContainer(for: schema, configurations: [cloudConfig, localConfig])
            self.modelContainer = container

            // Initialize services that need ModelContext
            let context = ModelContext(container)
            let workspaceStore = WorkspaceStore(modelContext: context)
            let windowMgr = WindowManager(workspaceStore: workspaceStore)
            self._windowManager = State(initialValue: windowMgr)

            // Ensure at least one workspace exists
            let settingsStore = SettingsStore(modelContext: context)
            if let activeId = settingsStore.activeWorkspaceId,
               let workspace = workspaceStore.workspace(id: activeId) {
                windowMgr.setActiveWorkspace(workspace)
            } else {
                let workspaces = workspaceStore.workspaces()
                if let first = workspaces.first {
                    windowMgr.setActiveWorkspace(first)
                    settingsStore.activeWorkspaceId = first.id
                } else {
                    let newWorkspace = workspaceStore.createWorkspace(name: "Default")
                    windowMgr.setActiveWorkspace(newWorkspace)
                    settingsStore.activeWorkspaceId = newWorkspace.id
                }
            }

            // Seed default labels on first launch (matches Android)
            let bookmarkStore = BookmarkStore(modelContext: context)
            let bookmarkService = BookmarkService(store: bookmarkStore)
            bookmarkService.prepareDefaultLabels()
            // Ensure system labels use deterministic UUIDs for CloudKit dedup
            bookmarkService.ensureSystemLabels()

            // Start monitoring iCloud account status
            sync.startMonitoring(container: container)
        } catch {
            fatalError("Failed to initialize SwiftData: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if showCalculator && !isUnlocked {
                    CalculatorView {
                        withAnimation {
                            isUnlocked = true
                        }
                    }
                } else {
                    ContentView()
                        .environment(windowManager)
                        .environment(syncService)
                        .environment(searchIndexService)
                }
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    // Reconcile icon state when app becomes active
                    // (setAlternateIconName fails if called before app is fully active)
                    updateAppIcon(discrete: isDiscreteMode)
                }
            }
            .onChange(of: isDiscreteMode) { _, newValue in
                updateAppIcon(discrete: newValue)
            }
            .onChange(of: showCalculator) { _, newValue in
                // When user turns off calculator gate, clear unlock state
                if !newValue {
                    isUnlocked = false
                }
            }
        }
        .modelContainer(modelContainer)
    }

    private func updateAppIcon(discrete: Bool, retryCount: Int = 0) {
        #if os(iOS)
        let iconName: String? = discrete ? "CalculatorIcon" : nil
        let currentIcon = UIApplication.shared.alternateIconName
        guard UIApplication.shared.supportsAlternateIcons,
              currentIcon != iconName else { return }
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if error != nil, retryCount < 3 {
                // Retry with increasing delay (startup timing can cause transient failures)
                let delay = Double(retryCount + 1) * 1.5
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.updateAppIcon(discrete: discrete, retryCount: retryCount + 1)
                }
            }
        }
        #endif
    }
}
