// DictionaryBrowserView.swift — Searchable key browser for dictionary/lexicon modules

import SwiftUI
import SwordKit

/**
 Searchable key browser for dictionary and lexicon modules.

 The view loads every key from the selected SWORD module, keeps them in memory, and filters the
 list locally as the user types. This mirrors Android's `ChooseDictionaryWord` flow.

 Data dependencies:
 - `module` is the selected dictionary module whose keys should be listed
 - `onSelectKey` notifies the parent when the user chooses a key to open

 Side effects:
 - loads the module key list asynchronously when the view appears
 - dismisses the sheet when the user taps the toolbar Done action
 */
struct DictionaryBrowserView: View {
    /// Dictionary module whose keys are being browsed.
    let module: SwordModule

    /// Callback invoked when the user chooses a dictionary key.
    let onSelectKey: (String) -> Void

    /// Live search text used to filter the loaded key list.
    @State private var searchText = ""

    /// Complete list of keys loaded from the module.
    @State private var allKeys: [String] = []

    /// Whether the module key list is still loading.
    @State private var isLoading = true

    /// Dismiss action for closing the browser.
    @Environment(\.dismiss) private var dismiss

    /// Keys matching the current search text.
    private var filteredKeys: [String] {
        if searchText.isEmpty { return allKeys }
        return allKeys.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }

    /**
     Builds the loading state, searchable key list, and empty-search state.
     */
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView(String(localized: "dictionary_loading_keys"))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if filteredKeys.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                } else {
                    List(filteredKeys, id: \.self) { key in
                        Button(key) {
                            onSelectKey(key)
                        }
                        .buttonStyle(.plain)
                    }
                    .listStyle(.plain)
                }
            }
            .searchable(text: $searchText, prompt: String(localized: "dictionary_search_keys"))
            .navigationTitle(module.info.description)
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
