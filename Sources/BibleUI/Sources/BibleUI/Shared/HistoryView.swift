// HistoryView.swift — Navigation history

import SwiftUI
import SwiftData
import BibleCore

/**
 Displays navigation history for the active reader window and lets the user jump back to prior locations.

 The view filters persisted history to the active window when possible, formats stored OSIS-style keys
 into user-visible references, and offers row deletion plus full-history clearing.

 Data dependencies:
 - `modelContext` is used to delete persisted history rows
 - `windowManager` determines which window's history should be shown
 - `bookNameResolver` can translate OSIS book IDs using the active module's dynamic canon

 Side effects:
 - selecting a row dismisses the sheet and invokes `onNavigate`
 - swipe deletion and clear-all actions remove persisted history items from SwiftData
 */
public struct HistoryView: View {
    /// SwiftData context used for deleting history rows.
    @Environment(\.modelContext) private var modelContext

    /// Shared window manager used to scope history to the active window.
    @Environment(WindowManager.self) private var windowManager

    /// Dismiss action for closing the history screen.
    @Environment(\.dismiss) private var dismiss

    /// All persisted history items ordered newest-first.
    @Query(sort: \HistoryItem.createdAt, order: .reverse) private var allHistory: [HistoryItem]

    /// Callback invoked when the user chooses a history item to navigate back to.
    var onNavigate: ((String, Int) -> Void)?

    /// Resolves an OSIS book ID to a human-readable name using the active controller's dynamic book list.
    var bookNameResolver: ((String) -> String?)?

    /**
     Creates the history screen.

     - Parameters:
       - bookNameResolver: Optional resolver that maps OSIS IDs to dynamic, module-aware book names.
       - onNavigate: Optional callback invoked with `(bookName, chapter)` when a row is selected.
     */
    public init(bookNameResolver: ((String) -> String?)? = nil, onNavigate: ((String, Int) -> Void)? = nil) {
        self.bookNameResolver = bookNameResolver
        self.onNavigate = onNavigate
    }

    /// Filter history to the active window only.
    private var history: [HistoryItem] {
        guard let windowId = windowManager.activeWindow?.id else { return allHistory }
        return allHistory.filter { $0.window?.id == windowId }
    }

    /**
     Builds the empty state or filtered history list with destructive toolbar actions.
     */
    public var body: some View {
        Group {
            if history.isEmpty {
                ContentUnavailableView(
                    String(localized: "history_no_history"),
                    systemImage: "clock",
                    description: Text(String(localized: "history_no_history_description"))
                )
            } else {
                List {
                    ForEach(history) { item in
                        Button {
                            navigateTo(item)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(formatKey(item.key))
                                        .font(.headline)
                                    Text(item.document)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(item.createdAt, style: .time)
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete(perform: deleteItems)
                }
            }
        }
        .navigationTitle(String(localized: "history"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(String(localized: "done")) { dismiss() }
            }
            if !history.isEmpty {
                ToolbarItem(placement: .destructiveAction) {
                    Button(String(localized: "clear"), role: .destructive) {
                        clearHistory()
                    }
                }
            }
        }
    }

    /**
     Formats a stored OSIS-like history key such as `Gen.1.1` into a user-visible `Book Chapter` label.
     */
    private func formatKey(_ key: String) -> String {
        let parts = key.split(separator: ".")
        guard parts.count >= 2 else { return key }
        let osisId = String(parts[0])
        let chapter = String(parts[1])
        let bookName = bookNameResolver?(osisId) ?? BibleReaderController.bookName(forOsisId: osisId) ?? osisId
        return "\(bookName) \(chapter)"
    }

    /**
     Dismisses the history view and forwards the selected location to the navigation callback.
     */
    private func navigateTo(_ item: HistoryItem) {
        let parts = item.key.split(separator: ".")
        guard parts.count >= 2 else { return }
        let osisId = String(parts[0])
        let chapter = Int(parts[1]) ?? 1
        let bookName = bookNameResolver?(osisId) ?? BibleReaderController.bookName(forOsisId: osisId) ?? osisId
        dismiss()
        onNavigate?(bookName, chapter)
    }

    /**
     Deletes the rows referenced by the given list offsets from the filtered history list.
     */
    private func deleteItems(at offsets: IndexSet) {
        let toDelete = offsets.map { history[$0] }
        for item in toDelete {
            modelContext.delete(item)
        }
        try? modelContext.save()
    }

    /**
     Deletes every currently visible history row for the active window scope.
     */
    private func clearHistory() {
        for item in history {
            modelContext.delete(item)
        }
        try? modelContext.save()
    }
}
