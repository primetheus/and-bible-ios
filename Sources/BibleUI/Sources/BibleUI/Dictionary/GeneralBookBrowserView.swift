// GeneralBookBrowserView.swift — Flat key list browser for general books and maps

import SwiftUI
import SwordKit

/**
 Flat key browser for general-book and map modules.

 Unlike `DictionaryBrowserView`, this view presents the full key list without local search and is
 reused for both `.generalBook` and `.map` SWORD categories.

 Data dependencies:
 - `module` is the selected module whose keys should be listed
 - `title` is the user-visible navigation title supplied by the caller
 - `onSelectKey` notifies the parent when the user chooses an entry key

 Side effects:
 - loads the module key list asynchronously when the view appears
 - dismisses the sheet when the user taps the toolbar Done action
 */
struct GeneralBookBrowserView: View {
    /// Module whose flat key list is being browsed.
    let module: SwordModule

    /// Navigation title shown while browsing the module.
    let title: String

    /// Callback invoked when the user chooses an entry key.
    let onSelectKey: (String) -> Void

    /// Complete key list loaded from the module.
    @State private var allKeys: [String] = []

    /// Whether the module key list is still loading.
    @State private var isLoading = true

    /// Dismiss action for closing the browser.
    @Environment(\.dismiss) private var dismiss

    /**
     Builds the loading state, empty state, or flat key list.
     */
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView(String(localized: "genbook_loading_entries"))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if allKeys.isEmpty {
                    ContentUnavailableView(
                        String(localized: "genbook_no_entries"),
                        systemImage: "book.closed",
                        description: Text(String(localized: "genbook_no_entries_description"))
                    )
                } else {
                    List(allKeys, id: \.self) { key in
                        Button(key) {
                            onSelectKey(key)
                        }
                        .buttonStyle(.plain)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle(title)
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "done")) { dismiss() }
                }
            }
            .task {
                let keys = await Task.detached { [module] in
                    module.allKeys()
                }.value
                allKeys = keys
                isLoading = false
            }
        }
    }
}
