// WorkspaceSelectorView.swift — Workspace selection and management

import SwiftUI
import SwiftData
import BibleCore

/**
 Lets the user switch workspaces and manage workspace lifecycle actions from one list.

 The view shows all persisted workspaces in display order, supports switching the active workspace,
 and exposes create, rename, clone, delete, and reorder actions.

 Data dependencies:
 - `windowManager` provides the active workspace and performs active-workspace switching
 - `modelContext` is used by `WorkspaceStore` for create/update/delete/reorder operations
 - `workspaces` is a live SwiftData query ordered by persisted workspace order

 Side effects:
 - selecting a row switches the active workspace and dismisses the sheet
 - alerts create, rename, or clone workspaces through `WorkspaceStore`
 - swipe deletion, context-menu deletion, and move actions mutate persisted workspace state
 */
public struct WorkspaceSelectorView: View {
    /// Shared window manager used to switch the active workspace.
    @Environment(WindowManager.self) private var windowManager

    /// SwiftData context used by `WorkspaceStore` mutations.
    @Environment(\.modelContext) private var modelContext

    /// Controls presentation of the create-workspace alert.
    @State private var showNewWorkspace = false

    /// Draft name for the create-workspace alert.
    @State private var newWorkspaceName = ""

    /// Controls presentation of the rename-workspace alert.
    @State private var showRenameWorkspace = false

    /// Draft name for the rename-workspace alert.
    @State private var renameWorkspaceName = ""

    /// Workspace currently targeted by the rename flow.
    @State private var workspaceToRename: Workspace?

    /// Controls presentation of the clone-workspace alert.
    @State private var showCloneWorkspace = false

    /// Draft name for the clone-workspace alert.
    @State private var cloneWorkspaceName = ""

    /// Workspace currently targeted by the clone flow.
    @State private var workspaceToClone: Workspace?

    /// Dismiss action for closing the selector screen.
    @Environment(\.dismiss) private var dismiss

    /// Persisted workspaces ordered by `orderNumber`.
    @Query(sort: \Workspace.orderNumber) private var workspaces: [Workspace]

    /**
     Creates the workspace selector screen.

     - Note: This initializer has no inputs and performs no side effects.
     */
    public init() {}

    /**
     Builds the workspace list, management alerts, and toolbar actions.
     */
    public var body: some View {
        List {
            if workspaces.isEmpty {
                Section {
                    VStack(spacing: 8) {
                        Text(String(localized: "workspace_no_workspaces"))
                            .foregroundStyle(.secondary)
                        Text(String(localized: "workspace_create_first"))
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                }
            } else {
                Section(String(localized: "workspaces")) {
                    ForEach(workspaces) { workspace in
                        Button {
                            windowManager.setActiveWorkspace(workspace)
                            dismiss()
                        } label: {
                            workspaceRow(workspace)
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button(String(localized: "rename"), systemImage: "pencil") {
                                workspaceToRename = workspace
                                renameWorkspaceName = workspace.name
                                showRenameWorkspace = true
                            }

                            Button(String(localized: "clone"), systemImage: "doc.on.doc") {
                                workspaceToClone = workspace
                                cloneWorkspaceName = String(format: String(localized: "copy_of %@"), workspace.name)
                                showCloneWorkspace = true
                            }

                            Divider()

                            Button(String(localized: "delete"), systemImage: "trash", role: .destructive) {
                                guard workspace.id != windowManager.activeWorkspace?.id else { return }
                                let store = WorkspaceStore(modelContext: modelContext)
                                store.delete(workspace)
                            }
                            .disabled(workspace.id == windowManager.activeWorkspace?.id)
                        }
                    }
                    .onDelete(perform: deleteWorkspaces)
                    .onMove(perform: moveWorkspaces)
                }
            }
        }
        .navigationTitle(String(localized: "workspaces"))
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(String(localized: "done")) { dismiss() }
            }
            ToolbarItemGroup(placement: .primaryAction) {
                EditButton()
                Button(String(localized: "add"), systemImage: "plus") {
                    showNewWorkspace = true
                }
            }
        }
        .alert(String(localized: "workspace_new"), isPresented: $showNewWorkspace) {
            TextField(String(localized: "name"), text: $newWorkspaceName)
            Button(String(localized: "create")) {
                guard !newWorkspaceName.isEmpty else { return }
                let store = WorkspaceStore(modelContext: modelContext)
                let workspace = store.createWorkspace(name: newWorkspaceName)
                windowManager.setActiveWorkspace(workspace)
                newWorkspaceName = ""
                dismiss()
            }
            Button(String(localized: "cancel"), role: .cancel) { newWorkspaceName = "" }
        }
        .alert(String(localized: "rename"), isPresented: $showRenameWorkspace) {
            TextField(String(localized: "name"), text: $renameWorkspaceName)
            Button(String(localized: "save")) {
                guard !renameWorkspaceName.isEmpty, let workspace = workspaceToRename else { return }
                let store = WorkspaceStore(modelContext: modelContext)
                store.renameWorkspace(workspace, to: renameWorkspaceName)
                workspaceToRename = nil
                renameWorkspaceName = ""
            }
            Button(String(localized: "cancel"), role: .cancel) {
                workspaceToRename = nil
                renameWorkspaceName = ""
            }
        }
        .alert(String(localized: "clone"), isPresented: $showCloneWorkspace) {
            TextField(String(localized: "name"), text: $cloneWorkspaceName)
            Button(String(localized: "create")) {
                guard !cloneWorkspaceName.isEmpty, let workspace = workspaceToClone else { return }
                let store = WorkspaceStore(modelContext: modelContext)
                store.cloneWorkspace(workspace, newName: cloneWorkspaceName)
                workspaceToClone = nil
                cloneWorkspaceName = ""
            }
            Button(String(localized: "cancel"), role: .cancel) {
                workspaceToClone = nil
                cloneWorkspaceName = ""
            }
        }
    }

    /**
     Builds one workspace row with color indicator, summary text, and active-workspace marker.
     */
    private func workspaceRow(_ workspace: Workspace) -> some View {
        HStack {
            if let color = workspace.workspaceColor {
                Circle()
                    .fill(Color(argbInt: color))
                    .frame(width: 12, height: 12)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(workspace.name.isEmpty ? String(localized: "untitled") : workspace.name)
                    .font(.body)
                if let contents = workspace.contentsText, !contents.isEmpty {
                    Text(contents)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    let windowCount = workspace.windows?.count ?? 0
                    Text("\(windowCount) window\(windowCount == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            if workspace.id == windowManager.activeWorkspace?.id {
                Image(systemName: "checkmark")
                    .foregroundStyle(.blue)
            }
        }
    }

    /**
     Deletes the selected workspaces, skipping the currently active workspace.
     */
    private func deleteWorkspaces(at offsets: IndexSet) {
        let store = WorkspaceStore(modelContext: modelContext)
        for index in offsets {
            let workspace = workspaces[index]
            if workspace.id == windowManager.activeWorkspace?.id {
                continue
            }
            store.delete(workspace)
        }
    }

    /**
     Persists a reordered workspace list after drag-and-drop movement.
     */
    private func moveWorkspaces(from source: IndexSet, to destination: Int) {
        var reordered = Array(workspaces)
        reordered.move(fromOffsets: source, toOffset: destination)
        let store = WorkspaceStore(modelContext: modelContext)
        store.reorderWorkspaces(reordered)
    }
}
