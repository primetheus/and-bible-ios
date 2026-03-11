// EpubLibraryView.swift — Lists all installed EPUB files

import SwiftUI
import BibleCore

/**
 Library browser for installed EPUB books.

 The view loads all installed EPUB metadata, lets the caller open one selected book, and supports
 deleting library entries from the local EPUB store.

 Data dependencies:
 - `onSelectEpub` notifies the parent when the user chooses an EPUB identifier to open

 Side effects:
 - loads installed EPUB metadata when the view appears
 - deleting rows removes EPUB content through `EpubReader.delete`
 - dismisses the library browser when the toolbar Done action is used
 */
struct EpubLibraryView: View {
    /// Callback invoked when the user chooses an EPUB to open.
    let onSelectEpub: (String) -> Void

    /// Installed EPUB metadata loaded from the local library.
    @State private var epubs: [EpubInfo] = []

    /// Whether the EPUB library is still loading.
    @State private var isLoading = true

    /// Dismiss action for closing the library browser.
    @Environment(\.dismiss) private var dismiss

    /**
     Builds the loading state, empty library state, or installed EPUB list.
     */
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView(String(localized: "epub_loading_library"))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if epubs.isEmpty {
                    ContentUnavailableView(
                        String(localized: "epub_no_epubs_installed"),
                        systemImage: "book",
                        description: Text(String(localized: "epub_no_epubs_installed_description"))
                    )
                } else {
                    List {
                        ForEach(epubs, id: \.identifier) { epub in
                            Button {
                                onSelectEpub(epub.identifier)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(epub.title)
                                        .font(.headline)
                                        .lineLimit(2)
                                    if !epub.author.isEmpty {
                                        Text(epub.author)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(1)
                                    }
                                }
                                .padding(.vertical, 2)
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete(perform: deleteEpubs)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle(String(localized: "epub_library"))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "done")) { dismiss() }
                }
            }
            .task {
                epubs = EpubReader.installedEpubs()
                isLoading = false
            }
        }
    }

    /**
     Deletes the selected EPUBs from local storage and removes them from the in-memory list.

     - Parameter offsets: Selected row offsets in the current library list.
     */
    private func deleteEpubs(at offsets: IndexSet) {
        for index in offsets {
            let epub = epubs[index]
            EpubReader.delete(identifier: epub.identifier)
        }
        epubs.remove(atOffsets: offsets)
    }
}
