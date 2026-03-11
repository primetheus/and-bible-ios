// ShareSheet.swift — Cross-platform share sheet wrapper

import SwiftUI

#if os(iOS)
/**
 Wraps `UIActivityViewController` for SwiftUI presentations on iOS.

 Data dependencies:
 - `items` supplies the activity items passed through to the system share sheet
 */
struct ShareSheet: UIViewControllerRepresentable {
    /// Items to expose through the native share sheet.
    let items: [Any]

    /**
     Creates the UIKit share-sheet controller.

     - Parameter context: SwiftUI context for the representable lifecycle.
     - Returns: Configured `UIActivityViewController` presenting the supplied share items.
     */
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    /**
     Updates the share-sheet controller after creation.

     - Parameters:
       - uiViewController: Previously created activity controller.
       - context: SwiftUI context for the representable lifecycle.
     - Note: The controller has no incremental update path after creation.
     */
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
#elseif os(macOS)
/**
 Provides a simple SwiftUI share fallback on macOS.

 The macOS implementation does not currently bridge `NSSharingServicePicker`; instead it exposes
 the first share item as text and provides a copy-to-clipboard action.

 Data dependencies:
 - `items` provides the share payload, with the first string item used for display and clipboard
   copying

 Side effects:
 - tapping the copy button writes the first string item to the general pasteboard
 */
struct ShareSheet: View {
    /// Items supplied for sharing.
    let items: [Any]

    /**
     Builds the macOS share fallback view.
     */
    var body: some View {
        VStack(spacing: 12) {
            Text("Share")
                .font(.headline)
            if let text = items.first as? String {
                Text(text)
                    .font(.body)
                    .padding()
                    .textSelection(.enabled)
            }
            Button("Copy to Clipboard") {
                if let text = items.first as? String {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(text, forType: .string)
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(minWidth: 300)
    }
}
#endif
