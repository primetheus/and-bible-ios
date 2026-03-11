// StudyPad.swift -- StudyPad (journal) entry models

import Foundation
import SwiftData

/**
 Stores one rich-text row inside a label-backed StudyPad document.

 StudyPad entries are ordered, nestable notes that live under a `Label`. The heavy text
 payload is split into `StudyPadTextEntryText` so list queries can fetch ordering and
 hierarchy metadata without loading the full note body.
 */
@Model
public final class StudyPadTextEntry {
    /// Unique identifier used for SwiftData identity and 1:1 text payload linkage.
    @Attribute(.unique) public var id: UUID

    /// Parent label that owns this StudyPad entry; deleting the label removes the entry.
    public var label: Label?

    /// Zero-based display order within the label's StudyPad outline.
    public var orderNumber: Int

    /// Hierarchy depth used by the StudyPad outline renderer.
    public var indentLevel: Int

    /// Rich-text payload stored in a companion entity and cascade-deleted with the entry.
    @Relationship(deleteRule: .cascade, inverse: \StudyPadTextEntryText.entry)
    public var textEntry: StudyPadTextEntryText?

    /**
     Creates a StudyPad entry shell.

     - Parameters:
       - id: Stable identifier for SwiftData persistence and text payload linkage.
       - orderNumber: Zero-based order within the parent label's outline.
       - indentLevel: Nesting level rendered by the StudyPad UI.
     - Note: Callers typically create the paired `StudyPadTextEntryText` immediately after
       insertion so the row has visible content.
     */
    public init(
        id: UUID = UUID(),
        orderNumber: Int = 0,
        indentLevel: Int = 0
    ) {
        self.id = id
        self.orderNumber = orderNumber
        self.indentLevel = indentLevel
    }
}

/**
 Stores the heavy rich-text payload for a `StudyPadTextEntry`.

 Splitting the text body into a dedicated entity keeps StudyPad list queries lighter and
 allows cascade deletion to clean up payload rows automatically when the parent entry is
 removed.
 */
@Model
public final class StudyPadTextEntryText {
    /// Mirrors the parent entry identifier to enforce the intended 1:1 relationship.
    @Attribute(.unique) public var studyPadTextEntryId: UUID

    /// Back-reference to the owning StudyPad entry.
    public var entry: StudyPadTextEntry?

    /// Serialized note body shown in the StudyPad editor and renderer.
    public var text: String

    /**
     Creates the text payload entity for a StudyPad entry.

     - Parameters:
       - studyPadTextEntryId: Identifier of the owning `StudyPadTextEntry`.
       - text: Persisted note content. Empty by default so callers can create the payload
         before the user enters text.
     */
    public init(studyPadTextEntryId: UUID, text: String = "") {
        self.studyPadTextEntryId = studyPadTextEntryId
        self.text = text
    }
}
