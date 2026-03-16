# Reader Parity

This directory holds parity documentation for the main reading experience.

## Reading Order

1. [contract.md](contract.md): reader behaviors that intentionally mirror Android
2. [dispositions.md](dispositions.md): explicit iOS adaptations for those behaviors
3. [verification-matrix.md](verification-matrix.md): current status by contract area
4. [regression-report.md](regression-report.md): focused validation evidence

Companion docs:

- [../settings/contract.md](../settings/contract.md): Android application-preference
  baseline that feeds many reader behaviors
- [../bridge/contract.md](../bridge/contract.md): shared bridge contract used by the
  embedded document client

Primary references:

- `Sources/BibleUI/Sources/BibleUI/Bible/BibleReaderView.swift`
- `Sources/BibleUI/Sources/BibleUI/Bible/BibleReaderController.swift`
- `Sources/BibleUI/Sources/BibleUI/Bible/BibleWindowPane.swift`
- `Sources/BibleView/Sources/BibleView/WebViewCoordinator.swift`
- `Sources/BibleUI/Sources/BibleUI/Shared/HistoryView.swift`
- `Sources/BibleUI/Sources/BibleUI/Workspace/WorkspaceSelectorView.swift`
