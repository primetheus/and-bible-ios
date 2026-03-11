// DocumentCategory.swift -- Document type categories

import Foundation

/**
 Describes the high-level module categories that PageManager persists for each window.

 The raw values mirror Android/SWORD naming used throughout the app, so callers should
 treat them as persistence and bridge contract values rather than presentation strings.
 */
public enum DocumentCategory: String, Codable, Sendable {
    case bible = "BIBLE"
    case commentary = "COMMENTARY"
    case generalBook = "GENERAL_BOOK"
    case dictionary = "DICTIONARY"
    case map = "MAP"
    case epub = "EPUB"
    case dailyDevotion = "DAILY_DEVOTION"

    /// Returns the PageManager field prefix used to persist state for this category.
    public var pageManagerKey: String {
        switch self {
        case .bible: return "bible"
        case .commentary: return "commentary"
        case .dictionary: return "dictionary"
        case .generalBook: return "general_book"
        case .map: return "map"
        case .epub: return "epub"
        case .dailyDevotion: return "daily_devotion"
        }
    }
}

/**
 Declares the reading direction expected by rendered document content.

 The enum is serialized into view-model state and does not itself mutate shared state.
 */
public enum TextDirection: String, Codable, Sendable {
    case ltr
    case rtl
}

/**
 Enumerates the versification systems the app recognizes when converting ordinals,
 resolving references, and persisting module-specific Bible positions.

 Unknown raw values are coerced to `.kjva` by `init(string:)` so callers always receive
 a valid enum for downstream persistence and navigation logic.
 */
public enum Versification: String, Codable, Sendable {
    case kjv = "KJV"
    case kjva = "KJVA"
    case nrsv = "NRSV"
    case nrsva = "NRSVA"
    case mt = "MT"
    case leningrad = "Leningrad"
    case synodal = "Synodal"
    case synodalProt = "SynodalProt"
    case vulg = "Vulg"
    case luther = "Luther"
    case german = "German"
    case catholic = "Catholic"
    case catholic2 = "Catholic2"
    case lxx = "LXX"
    case orthodox = "Orthodox"
    case calvin = "Calvin"
    case darbyFr = "DarbyFr"
    case segond = "Segond"
    case custom = "Custom"

    /**
     Creates a versification from persisted or bridged raw text.

     - Parameter string: Raw versification name stored by SWORD, Android parity code, or
       serialized page state.
     - Note: Falls back to `.kjva` when the input is unknown so callers do not need to
       handle optional parsing failures.
     */
    public init(string: String) {
        self = Versification(rawValue: string) ?? .kjva
    }
}
