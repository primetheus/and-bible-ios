import UIKit

/// Shared policy for whether iPadOS 26 window controls should use the minimal style.
public struct AndBibleWindowingControlPolicy {
    public static func shouldUseMinimalStyle(userInterfaceIdiom: UIUserInterfaceIdiom) -> Bool {
        userInterfaceIdiom == .pad
    }
}
