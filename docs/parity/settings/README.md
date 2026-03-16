# Settings Parity

This directory is the source of truth for Android application-settings parity
work on iOS.

## Reading Order

1. [contract.md](contract.md): Android settings contract baseline
2. [dispositions.md](dispositions.md): explicit iOS divergences/adaptations
3. [verification-matrix.md](verification-matrix.md): current key-by-key status
4. [regression-report.md](regression-report.md): validation evidence
5. [guardrails.md](guardrails.md): localization and parity guardrails

Supporting artifacts:

- `baselines/`: machine-readable snapshots used by guardrails
- `archive/`: historical or one-off analysis that should not be in the main
  reading path
