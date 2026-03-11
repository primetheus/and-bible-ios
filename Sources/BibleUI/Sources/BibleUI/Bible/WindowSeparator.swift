// WindowSeparator.swift -- Draggable separator between Bible windows

import SwiftUI
import BibleCore

/**
 Renders the draggable divider between two visible Bible panes.

 The separator mutates `layoutWeight` on the two adjacent `Window` models using the same
 proportional drag logic as Android's `Separator.kt`: the drag distance is normalized by the
 average pane size, then applied as a weight delta with a hard minimum clamp.
 */
struct WindowSeparator: View {
    /// Leading or upper window whose layout weight grows when dragged toward it.
    let window1: Window

    /// Trailing or lower window whose layout weight shrinks when dragged toward `window1`.
    let window2: Window

    /// `true` for a horizontal separator between vertically stacked panes.
    let isVertical: Bool

    /// Number of currently visible panes used to compute the average pane size.
    let totalPaneCount: Int

    /// Total available width or height of the parent container, depending on orientation.
    let parentSize: CGFloat

    /// Tracks whether the current drag gesture is actively resizing panes.
    @State private var isDragging = false

    /// Snapshot of `window1.layoutWeight` captured at the start of a drag.
    @State private var startWeight1: Float = 1.0

    /// Snapshot of `window2.layoutWeight` captured at the start of a drag.
    @State private var startWeight2: Float = 1.0

    /// Visual thickness of the separator bar itself.
    private let separatorThickness: CGFloat = 4

    /// Minimum allowed layout weight for either pane during resizing.
    private let minWeight: Float = 0.1

    var body: some View {
        Rectangle()
            .fill(isDragging ? Color.accentColor : Color.gray.opacity(0.5))
            .frame(
                width: isVertical ? nil : separatorThickness,
                height: isVertical ? separatorThickness : nil
            )
            .contentShape(Rectangle().inset(by: -20)) // expanded touch target
            .gesture(
                DragGesture(minimumDistance: 1)
                    .onChanged { value in
                        if !isDragging {
                            isDragging = true
                            startWeight1 = window1.layoutWeight
                            startWeight2 = window2.layoutWeight
                        }

                        let aveScreenSize = parentSize / CGFloat(totalPaneCount)
                        guard aveScreenSize > 0 else { return }

                        let translation = isVertical ? value.translation.height : value.translation.width
                        let variationPercent = Float(translation / aveScreenSize)

                        window1.layoutWeight = max(minWeight, startWeight1 + variationPercent)
                        window2.layoutWeight = max(minWeight, startWeight2 - variationPercent)
                    }
                    .onEnded { _ in
                        isDragging = false
                    }
            )
            .onHover { hovering in
                #if os(macOS)
                if hovering {
                    NSCursor.resizeUpDown.push()
                } else {
                    NSCursor.pop()
                }
                #endif
            }
    }
}
