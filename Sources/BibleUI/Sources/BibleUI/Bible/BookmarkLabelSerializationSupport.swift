import Foundation
import SwiftData
import BibleCore

/**
 Normalizes bookmark-to-label relationships into the JSON-ready pieces consumed by the reader web
 layer.

 The reader previously dereferenced `Label.id` directly from live SwiftData relationship objects.
 That is unsafe when a `Label` has already been deleted but bookmark junction rows still hold a
 stale in-memory reference. This helper filters those deleted labels before serialization so the
 native reader can tolerate both in-flight deletions and older orphaned relationship state.
 */
struct BookmarkLabelSerializationPayload: Equatable {
    /// Ordered label identifiers that should be emitted on the bookmark JSON object.
    let labelIDs: [String]

    /// Pre-rendered JSON fragments for bookmark-to-label junction rows.
    let relationItemsJSON: [String]

    /**
     Renders the ordered label identifiers as a JSON array string.

     - Returns: JSON array text containing the serialized `labelIDs` values.
     - Side effects: none.
     - Failure modes: This computed property cannot fail.
     */
    var labelsJSON: String {
        "[" + labelIDs.map { "\"\($0)\"" }.joined(separator: ",") + "]"
    }

    /**
     Renders the bookmark-to-label relation fragments as a JSON array string.

     - Returns: JSON array text containing the serialized `relationItemsJSON` fragments.
     - Side effects: none.
     - Failure modes: This computed property cannot fail.
     */
    var relationsJSON: String {
        "[" + relationItemsJSON.joined(separator: ",") + "]"
    }
}

/**
 Provides defensive serialization helpers for bookmark-to-label relationship graphs.

 Data dependencies:
 - consumes live SwiftData `Label`, `BibleBookmarkToLabel`, and `GenericBookmarkToLabel` models
 - reads `PersistentModel.isDeleted` to distinguish still-live labels from stale deleted objects

 Side effects:
 - none; all helpers are pure transformations over the provided model graph

 Failure modes:
 - deleted or missing labels are filtered out instead of being serialized
 - when every relationship row is invalid, callers receive an unlabeled fallback payload
 */
enum BookmarkLabelSerializationSupport {
    /**
     Resolves one label's UUID string only when the underlying SwiftData model is still live.

     - Parameter label: Optional label relationship object from a bookmark junction row.
     - Returns: The label UUID string when the label exists and is not deleted, otherwise `nil`.
     - Side effects: none.
     - Failure modes:
       - returns `nil` when `label` is absent
       - returns `nil` when `label.isDeleted` is `true`
     */
    static func liveLabelIDString(for label: Label?) -> String? {
        guard let label, !label.isDeleted else { return nil }
        return label.id.uuidString
    }

    /**
     Serializes Bible bookmark label relationships into reader JSON payload pieces.

     - Parameters:
       - bookmarkID: Identifier of the owning Bible bookmark.
       - links: Optional bookmark-to-label relationship rows attached to that bookmark.
       - unlabeledLabelID: Synthetic unlabeled label identifier used when no valid labels remain.
     - Returns: Ordered label identifiers plus JSON fragments for the surviving relation rows.
     - Side effects: none.
     - Failure modes:
       - filters out relationship rows whose `label` is missing or already deleted
       - falls back to one unlabeled synthetic relation when every relationship row is invalid
     */
    static func biblePayload(
        bookmarkID: UUID,
        links: [BibleBookmarkToLabel]?,
        unlabeledLabelID: String
    ) -> BookmarkLabelSerializationPayload {
        let resolvedLabelIDs = links?.compactMap { liveLabelIDString(for: $0.label) } ?? []
        let labelIDs = resolvedLabelIDs.isEmpty ? [unlabeledLabelID] : resolvedLabelIDs

        let relationItemsJSON = links?.compactMap { link -> String? in
            guard let labelID = liveLabelIDString(for: link.label) else { return nil }
            return """
            {"type":"BibleBookmarkToLabel","bookmarkId":"\(bookmarkID.uuidString)","labelId":"\(labelID)","orderNumber":\(link.orderNumber),"indentLevel":\(link.indentLevel),"expandContent":\(link.expandContent)}
            """
        } ?? []

        if relationItemsJSON.isEmpty {
            return BookmarkLabelSerializationPayload(
                labelIDs: labelIDs,
                relationItemsJSON: [
                    """
                    {"type":"BibleBookmarkToLabel","bookmarkId":"\(bookmarkID.uuidString)","labelId":"\(unlabeledLabelID)","orderNumber":0,"indentLevel":0,"expandContent":false}
                    """
                ]
            )
        }

        return BookmarkLabelSerializationPayload(
            labelIDs: labelIDs,
            relationItemsJSON: relationItemsJSON
        )
    }

    /**
     Serializes generic bookmark label relationships into reader JSON payload pieces.

     - Parameters:
       - bookmarkID: Identifier of the owning generic bookmark.
       - links: Optional bookmark-to-label relationship rows attached to that bookmark.
       - unlabeledLabelID: Synthetic unlabeled label identifier used when no valid labels remain.
     - Returns: Ordered label identifiers plus JSON fragments for the surviving relation rows.
     - Side effects: none.
     - Failure modes:
       - filters out relationship rows whose `label` is missing or already deleted
       - falls back to one unlabeled synthetic relation when every relationship row is invalid
     */
    static func genericPayload(
        bookmarkID: UUID,
        links: [GenericBookmarkToLabel]?,
        unlabeledLabelID: String
    ) -> BookmarkLabelSerializationPayload {
        let resolvedLabelIDs = links?.compactMap { liveLabelIDString(for: $0.label) } ?? []
        let labelIDs = resolvedLabelIDs.isEmpty ? [unlabeledLabelID] : resolvedLabelIDs

        let relationItemsJSON = links?.compactMap { link -> String? in
            guard let labelID = liveLabelIDString(for: link.label) else { return nil }
            return """
            {"type":"GenericBookmarkToLabel","bookmarkId":"\(bookmarkID.uuidString)","labelId":"\(labelID)","orderNumber":\(link.orderNumber),"indentLevel":\(link.indentLevel),"expandContent":\(link.expandContent)}
            """
        } ?? []

        if relationItemsJSON.isEmpty {
            return BookmarkLabelSerializationPayload(
                labelIDs: labelIDs,
                relationItemsJSON: [
                    """
                    {"type":"GenericBookmarkToLabel","bookmarkId":"\(bookmarkID.uuidString)","labelId":"\(unlabeledLabelID)","orderNumber":0,"indentLevel":0,"expandContent":false}
                    """
                ]
            )
        }

        return BookmarkLabelSerializationPayload(
            labelIDs: labelIDs,
            relationItemsJSON: relationItemsJSON
        )
    }

    /**
     Serializes a bookmark's primary label identifier only when it is still present in the emitted
     label set.

     - Parameters:
       - primaryLabelID: Optional stored primary-label UUID from the bookmark.
       - validLabelIDs: Ordered label identifiers that survived relation sanitization.
     - Returns: A quoted JSON string for the primary label identifier or `null`.
     - Side effects: none.
     - Failure modes:
       - returns `null` when `primaryLabelID` is absent
       - returns `null` when `primaryLabelID` no longer exists in `validLabelIDs`
     */
    static func primaryLabelIDJSON(primaryLabelID: UUID?, validLabelIDs: [String]) -> String {
        guard let primaryLabelID else { return "null" }
        let primaryLabel = primaryLabelID.uuidString
        return validLabelIDs.contains(primaryLabel) ? "\"\(primaryLabel)\"" : "null"
    }
}
