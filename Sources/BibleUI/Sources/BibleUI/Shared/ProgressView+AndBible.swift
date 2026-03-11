// ProgressView+AndBible.swift — Custom progress indicators

import SwiftUI

/**
 Displays module-download progress with both the module name and a percentage label.

 Data dependencies:
 - `moduleName` identifies the module currently being downloaded
 - `progress` is the normalized completion ratio shown in both text and the native progress view
 */
public struct DownloadProgressView: View {
    /// Name of the module currently being downloaded.
    let moduleName: String

    /// Normalized download progress from `0.0` to `1.0`.
    let progress: Double

    /**
     Creates a module-download progress view.

     - Parameters:
       - moduleName: Name of the module being downloaded.
       - progress: Normalized completion ratio from `0.0` to `1.0`.
     */
    public init(moduleName: String, progress: Double) {
        self.moduleName = moduleName
        self.progress = progress
    }

    /**
     Builds the progress label and native progress indicator.
     */
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(moduleName)
                    .font(.subheadline)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            ProgressView(value: progress)
        }
    }
}
