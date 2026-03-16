# Reading Plan Parity

This directory holds parity documentation for reading-plan templates and
reading-plan lifecycle behavior.

## Reading Order

1. [contract.md](contract.md): current reading-plan contract
2. [dispositions.md](dispositions.md): explicit iOS extensions and constraints
3. [verification-matrix.md](verification-matrix.md): current status by contract area
4. [regression-report.md](regression-report.md): focused validation evidence
5. [guardrails.md](guardrails.md): maintenance rules for high-risk reading-plan changes

Primary references:

- `Sources/BibleCore/Sources/BibleCore/Services/ReadingPlanService.swift`
- `Sources/BibleCore/Sources/BibleCore/Models/ReadingPlan.swift`
- `Sources/BibleUI/Sources/BibleUI/ReadingPlans/`
- `Sources/BibleCore/Sources/BibleCore/Services/RemoteSyncReadingPlanRestoreService.swift`
- `Sources/BibleCore/Sources/BibleCore/Services/RemoteSyncReadingPlanPatchApplyService.swift`
- `Sources/BibleCore/Sources/BibleCore/Services/RemoteSyncReadingPlanPatchUploadService.swift`
