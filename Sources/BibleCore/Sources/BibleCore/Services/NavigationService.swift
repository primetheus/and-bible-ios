// NavigationService.swift — Bible navigation and history

import Foundation
import Observation
import SwordKit

/**
 Manages Bible navigation and an in-memory back/forward stack.

 This service has two distinct history layers:
 - transient in-memory `backStack` / `forwardStack` entries for back/forward UI behavior
 - persisted `HistoryItem` rows written through `WorkspaceStore` for longer-lived navigation
   history

 The current key parser is intentionally simple and expects dotted numeric keys in the form
 `book.chapter.verse`. It does not yet delegate to SWORD's richer key/OSIS parsing.
 */
@Observable
public final class NavigationService {
    private let swordManager: SwordManager
    private let workspaceStore: WorkspaceStore

    /// Navigation history stack for back/forward.
    private var backStack: [NavigationEntry] = []
    private var forwardStack: [NavigationEntry] = []

    /// Whether a back navigation step is currently available.
    public var canGoBack: Bool { !backStack.isEmpty }
    /// Whether a forward navigation step is currently available.
    public var canGoForward: Bool { !forwardStack.isEmpty }

    /**
     Creates a navigation service.
     - Parameters:
       - swordManager: Manager used to resolve and render module content.
       - workspaceStore: Store used to persist navigation history entries.
     */
    public init(swordManager: SwordManager, workspaceStore: WorkspaceStore) {
        self.swordManager = swordManager
        self.workspaceStore = workspaceStore
    }

    /**
     Navigates a window to a new module/key pair.
     - Parameters:
       - module: Target Bible module abbreviation.
       - key: Dotted numeric key in `book.chapter.verse` form.
       - window: Window whose `PageManager` should be updated.
     - Note: The previous location is pushed to `backStack`, `forwardStack` is cleared, and a
       persisted `HistoryItem` row is written through `WorkspaceStore`.
     */
    public func navigateTo(module: String, key: String, window: Window) {
        // Push current position to back stack
        if let pm = window.pageManager, let doc = pm.bibleDocument {
            let currentKey = buildKeyString(pm)
            backStack.append(NavigationEntry(document: doc, key: currentKey))
            forwardStack.removeAll()
        }

        // Update page manager
        if let pm = window.pageManager {
            pm.bibleDocument = module
            // Parse the key to update verse position
            parseAndSetKey(key, on: pm)
        }

        // Record history
        workspaceStore.addHistoryItem(to: window, document: module, key: key)
    }

    /**
     Restores the most recent back-stack entry for a window.
     - Parameter window: Window whose current location should be replaced.
     */
    public func goBack(window: Window) {
        guard let entry = backStack.popLast() else { return }

        // Push current to forward stack
        if let pm = window.pageManager, let doc = pm.bibleDocument {
            forwardStack.append(NavigationEntry(document: doc, key: buildKeyString(pm)))
        }

        // Restore the back entry
        if let pm = window.pageManager {
            pm.bibleDocument = entry.document
            parseAndSetKey(entry.key, on: pm)
        }
    }

    /**
     Restores the most recent forward-stack entry for a window.
     - Parameter window: Window whose current location should be replaced.
     */
    public func goForward(window: Window) {
        guard let entry = forwardStack.popLast() else { return }

        if let pm = window.pageManager, let doc = pm.bibleDocument {
            backStack.append(NavigationEntry(document: doc, key: buildKeyString(pm)))
        }

        if let pm = window.pageManager {
            pm.bibleDocument = entry.document
            parseAndSetKey(entry.key, on: pm)
        }
    }

    /**
     Renders the current chapter text for a module at a specific key.
     - Parameters:
       - module: Target Bible module abbreviation.
       - key: Key to set on the module before rendering.
     - Returns: Rendered chapter text when the module exists, otherwise `nil`.
     */
    public func getChapterText(module: String, key: String) -> String? {
        guard let mod = swordManager.module(named: module) else { return nil }
        mod.setKey(key)
        return mod.renderText()
    }

    // MARK: - Private

    private func buildKeyString(_ pm: PageManager) -> String {
        guard let book = pm.bibleBibleBook,
              let chapter = pm.bibleChapterNo,
              let verse = pm.bibleVerseNo else { return "" }
        return "\(book).\(chapter).\(verse)"
    }

    private func parseAndSetKey(_ key: String, on pm: PageManager) {
        // Simple key parsing — full implementation would use SWORD's key parser
        let parts = key.split(separator: ".")
        if parts.count >= 3 {
            pm.bibleBibleBook = Int(parts[0])
            pm.bibleChapterNo = Int(parts[1])
            pm.bibleVerseNo = Int(parts[2])
        }
    }
}

/// A navigation history entry.
struct NavigationEntry {
    let document: String
    let key: String
}
