// EpubSearchView.swift — Full-text search within an EPUB

import SwiftUI
import BibleCore

/**
 Full-text search screen for one EPUB book.

 The view delegates searches to `EpubReader` and presents matching href/title/snippet tuples for
 in-book navigation.

 Data dependencies:
 - `reader` provides the book metadata and executes the EPUB search query
 - `onSelectHref` notifies the parent when the user chooses a matching href

 Side effects:
 - submitting the search field mutates search state and runs an EPUB search
 - dismisses the search screen when the toolbar Done action is used
 */
struct EpubSearchView: View {
    /// Reader for the EPUB currently being searched.
    let reader: EpubReader

    /// Callback invoked when the user chooses a matching href.
    let onSelectHref: (String) -> Void

    /// Current query text bound to the searchable field.
    @State private var searchText = ""

    /// Current search results as href/title/snippet tuples.
    @State private var results: [(href: String, title: String, snippet: String)] = []

    /// Whether an EPUB search is currently in progress.
    @State private var isSearching = false

    /// Whether the user has executed at least one search in this session.
    @State private var hasSearched = false

    /// Dismiss action for closing the EPUB search screen.
    @Environment(\.dismiss) private var dismiss

    /**
     Builds the pre-search prompt, loading state, empty-result state, or result list.
     */
    var body: some View {
        NavigationStack {
            Group {
                if !hasSearched {
                    ContentUnavailableView(
                        String(localized: "search_epub"),
                        systemImage: "magnifyingglass",
                        description: Text("Enter a search term to find text within \"\(reader.title)\".")
                    )
                } else if isSearching {
                    ProgressView(String(localized: "searching"))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if results.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                } else {
                    List(results.indices, id: \.self) { index in
                        let result = results[index]
                        Button {
                            onSelectHref(result.href)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(result.title)
                                    .font(.headline)
                                    .lineLimit(1)
                                Text(stripHTMLFromSnippet(result.snippet))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(3)
                            }
                            .padding(.vertical, 2)
                        }
                        .buttonStyle(.plain)
                    }
                    .listStyle(.plain)
                }
            }
            .searchable(text: $searchText, prompt: String(localized: "epub_search_prompt"))
            .onSubmit(of: .search) {
                performSearch()
            }
            .navigationTitle("Search: \(reader.title)")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "done")) { dismiss() }
                }
            }
        }
    }

    /**
     Executes the trimmed EPUB query and updates view state with the resulting hits.

     Failure modes:
     - returns without searching when the trimmed query is empty
     - zero-hit searches are treated as a valid outcome and leave `results` empty
     */
    private func performSearch() {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return }
        isSearching = true
        hasSearched = true

        results = reader.search(query: query)
        isSearching = false
    }

    /**
     Removes HTML markup from an EPUB search-result snippet for plain-text display.

     - Parameter snippet: HTML snippet returned by the EPUB search index.
     - Returns: Plain-text snippet with markup stripped via a regular-expression replacement.
     */
    private func stripHTMLFromSnippet(_ snippet: String) -> String {
        snippet.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
