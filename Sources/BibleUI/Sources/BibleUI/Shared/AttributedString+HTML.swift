// AttributedString+HTML.swift — Convert HTML to AttributedString for SwiftUI Text

import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

extension AttributedString {
    /**
     Creates an attributed string from an HTML body fragment.

     The initializer wraps the provided fragment in a minimal HTML document, applies a platform
     label color so text stays visible in light and dark appearances, then lets Foundation's HTML
     importer build the attributed result.

     - Parameters:
       - htmlBody: HTML fragment to wrap and import.
       - baseFont: Reserved base-font input retained for API compatibility. The current
         implementation does not translate it into CSS.
     - Throws: Any error surfaced by `NSAttributedString` HTML import.

     Failure modes:
     - if the generated HTML cannot be encoded as UTF-8, falls back to a plain attributed string
       initialized from `htmlBody`
     */
    init(htmlBody: String, baseFont: Font = .body) throws {
        #if os(iOS)
        let labelColor = UIColor.label
        #elseif os(macOS)
        let labelColor = NSColor.labelColor
        #endif
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        #if os(iOS)
        labelColor.resolvedColor(with: UITraitCollection.current).getRed(&r, green: &g, blue: &b, alpha: &a)
        #elseif os(macOS)
        (labelColor.usingColorSpace(.sRGB) ?? labelColor).getRed(&r, green: &g, blue: &b, alpha: &a)
        #endif
        let colorCSS = "rgb(\(Int(r * 255)), \(Int(g * 255)), \(Int(b * 255)))"

        let html = """
        <html><head><style>
        body { font-family: -apple-system, system-ui; font-size: 16px; color: \(colorCSS); }
        a { color: \(colorCSS); }
        </style></head><body>\(htmlBody)</body></html>
        """
        guard let data = html.data(using: .utf8) else {
            self.init(htmlBody)
            return
        }
        #if os(iOS)
        let nsAttr = try NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )
        #elseif os(macOS)
        let nsAttr = try NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )
        #endif
        self.init(nsAttr)
    }
}
