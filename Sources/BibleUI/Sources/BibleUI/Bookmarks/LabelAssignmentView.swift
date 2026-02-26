// LabelAssignmentView.swift — Toggle labels on a bookmark

import SwiftUI
import SwiftData
import BibleCore
import os.log

private let logger = Logger(subsystem: "org.andbible", category: "LabelAssignment")

/// View for assigning/removing labels on a specific bookmark.
/// Shows all user labels with checkmarks for currently assigned ones.
/// Heart icon toggles favourite status (favourite labels appear in quick-assign bar).
/// Supports both BibleBookmark and GenericBookmark types.
struct LabelAssignmentView: View {
    let bookmarkId: UUID
    var onDismiss: (() -> Void)?

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \BibleCore.Label.name) private var allLabels: [BibleCore.Label]
    @State private var showNewLabel = false
    @State private var newLabelName = ""
    @State private var assignedLabelIds: Set<UUID> = []
    @State private var isGenericBookmark = false

    private var userLabels: [BibleCore.Label] {
        allLabels.filter { $0.isRealLabel }
    }

    var body: some View {
        let _ = logger.info("LabelAssignmentView body: bookmarkId=\(bookmarkId), allLabels=\(allLabels.count), userLabels=\(userLabels.count), assignedLabelIds=\(assignedLabelIds.count), isGeneric=\(isGenericBookmark)")
        List {
            Section {
                ForEach(userLabels) { label in
                    HStack(spacing: 10) {
                        Circle()
                            .fill(Color(argbInt: label.color))
                            .frame(width: 14, height: 14)

                        Text(label.name)
                            .font(.body)
                            .foregroundStyle(.primary)

                        Spacer()

                        Button {
                            toggleFavourite(label)
                        } label: {
                            Image(systemName: label.favourite ? "heart.fill" : "heart")
                                .foregroundStyle(label.favourite ? Color.red : Color.secondary)
                                .font(.body)
                        }
                        .buttonStyle(.plain)

                        Button {
                            toggleLabel(label)
                        } label: {
                            Image(systemName: assignedLabelIds.contains(label.id) ? "checkmark.square.fill" : "square")
                                .foregroundStyle(assignedLabelIds.contains(label.id) ? Color.accentColor : Color.secondary)
                                .font(.body)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            Section {
                Button {
                    showNewLabel = true
                } label: {
                    SwiftUI.Label("Create New Label", systemImage: "plus.circle")
                }
            }
        }
        .navigationTitle("Assign Labels")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    logger.info("Done button tapped, onDismiss=\(onDismiss != nil)")
                    onDismiss?()
                    dismiss()
                }
            }
        }
        .alert("New Label", isPresented: $showNewLabel) {
            TextField("Label name", text: $newLabelName)
            Button("Create") { createAndAssignLabel() }
            Button("Cancel", role: .cancel) { newLabelName = "" }
        }
        .onAppear { loadAssignedLabels() }
    }

    // MARK: - Bible Bookmark helpers

    private func fetchBibleBookmark() -> BibleBookmark? {
        let target = bookmarkId
        var descriptor = FetchDescriptor<BibleBookmark>(
            predicate: #Predicate { $0.id == target }
        )
        descriptor.fetchLimit = 1
        return try? modelContext.fetch(descriptor).first
    }

    private func fetchGenericBookmark() -> GenericBookmark? {
        let target = bookmarkId
        var descriptor = FetchDescriptor<GenericBookmark>(
            predicate: #Predicate { $0.id == target }
        )
        descriptor.fetchLimit = 1
        return try? modelContext.fetch(descriptor).first
    }

    private func loadAssignedLabels() {
        logger.info("loadAssignedLabels: looking for bookmarkId=\(bookmarkId)")
        // Try BibleBookmark first, then GenericBookmark
        if let bookmark = fetchBibleBookmark() {
            isGenericBookmark = false
            let ids = bookmark.bookmarkToLabels?.compactMap { $0.label?.id } ?? []
            assignedLabelIds = Set(ids)
            logger.info("loadAssignedLabels: found BibleBookmark, \(ids.count) labels assigned")
        } else if let bookmark = fetchGenericBookmark() {
            isGenericBookmark = true
            let ids = bookmark.bookmarkToLabels?.compactMap { $0.label?.id } ?? []
            assignedLabelIds = Set(ids)
            logger.info("loadAssignedLabels: found GenericBookmark, \(ids.count) labels assigned")
        } else {
            logger.error("loadAssignedLabels: NO bookmark found for id=\(bookmarkId)")
        }
    }

    private func toggleLabel(_ label: BibleCore.Label) {
        if isGenericBookmark {
            toggleGenericLabel(label)
        } else {
            toggleBibleLabel(label)
        }
    }

    private func toggleBibleLabel(_ label: BibleCore.Label) {
        logger.info("toggleBibleLabel: label=\(label.name) id=\(label.id)")
        guard let bookmark = fetchBibleBookmark() else {
            logger.error("toggleBibleLabel: bookmark NOT found for id=\(bookmarkId)")
            return
        }

        if assignedLabelIds.contains(label.id) {
            bookmark.bookmarkToLabels?.removeAll { $0.label?.id == label.id }
            assignedLabelIds.remove(label.id)
            logger.info("toggleBibleLabel: REMOVED label \(label.name)")
        } else {
            let btl = BibleBookmarkToLabel()
            btl.bookmark = bookmark
            btl.label = label
            modelContext.insert(btl)
            assignedLabelIds.insert(label.id)
            logger.info("toggleBibleLabel: ADDED label \(label.name)")
        }
        bookmark.lastUpdatedOn = Date()
        try? modelContext.save()
    }

    private func toggleGenericLabel(_ label: BibleCore.Label) {
        guard let bookmark = fetchGenericBookmark() else { return }

        if assignedLabelIds.contains(label.id) {
            bookmark.bookmarkToLabels?.removeAll { $0.label?.id == label.id }
            assignedLabelIds.remove(label.id)
        } else {
            let gbtl = GenericBookmarkToLabel()
            gbtl.bookmark = bookmark
            gbtl.label = label
            modelContext.insert(gbtl)
            assignedLabelIds.insert(label.id)
        }
        bookmark.lastUpdatedOn = Date()
        try? modelContext.save()
    }

    private func toggleFavourite(_ label: BibleCore.Label) {
        logger.info("toggleFavourite: label=\(label.name), was=\(label.favourite), now=\(!label.favourite)")
        label.favourite.toggle()
        try? modelContext.save()
    }

    private func createAndAssignLabel() {
        guard !newLabelName.isEmpty else { return }
        logger.info("createAndAssignLabel: name=\(newLabelName)")
        let label = BibleCore.Label(name: newLabelName)
        modelContext.insert(label)
        // Save the label first so SwiftData can establish relationships
        try? modelContext.save()

        if isGenericBookmark {
            if let bookmark = fetchGenericBookmark() {
                let gbtl = GenericBookmarkToLabel()
                gbtl.bookmark = bookmark
                gbtl.label = label
                modelContext.insert(gbtl)
                bookmark.lastUpdatedOn = Date()
                assignedLabelIds.insert(label.id)
            }
        } else {
            if let bookmark = fetchBibleBookmark() {
                let btl = BibleBookmarkToLabel()
                btl.bookmark = bookmark
                btl.label = label
                modelContext.insert(btl)
                bookmark.lastUpdatedOn = Date()
                assignedLabelIds.insert(label.id)
            }
        }
        try? modelContext.save()
        newLabelName = ""
    }
}
