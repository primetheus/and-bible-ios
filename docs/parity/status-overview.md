# Parity Status Overview

Date: 2026-03-16

## Purpose

This document is the top-level snapshot of current Android parity posture for
`and-bible-ios`.

Use it to answer four questions quickly:

1. what domains are formally documented
2. what their current parity posture is
3. what validation and automation currently protect them
4. where the remaining durable gaps still are

## Domain Snapshot

| Domain | Current Posture | Automation State | Primary Remaining Gap |
|---|---|---|---|
| [settings](settings/README.md) | Mature: `24 Pass`, `9 Adapted Pass`, `0 Partial`, `2 Documented Divergence` | Dedicated localization guardrail script, committed baselines, CI integration, focused simulator/unit validation | Broader machine-readable guardrails beyond localization if the settings surface grows materially |
| [sync](sync/README.md) | Strong but not fully locked: `4 Pass`, `2 Adapted Pass`, `3 Partial` | Focused unit/integration coverage, focused Sync UI coverage, explicit guardrails | Workspace sync not yet in a standard shared-scheme path; adopt/create confirmation UI still partial |
| [bookmarks](bookmarks/README.md) | Strong user-workflow coverage: `5 Pass`, `2 Adapted Pass`, `2 Partial` | Focused bookmark UI workflows plus note-persistence unit regressions | Generic-bookmark visible workflows and broader StudyPad mutation breadth |
| [search](search/README.md) | Strong semantic coverage: `5 Pass`, `2 Adapted Pass`, `1 Partial` | Focused search UI workflows plus Strong's unit regressions | Multi-translation search still lacks focused regression coverage |
| [reading-plans](reading-plans/README.md) | Strong sync and progression coverage: `5 Pass`, `1 Adapted Pass`, `3 Partial` | Focused daily-reading UI coverage plus restore/upload/patch unit coverage | Custom plan import, reading-plan list/start/import breadth, and additive iOS-only plan lifecycle coverage |
| [reader](reader/README.md) | Core shell workflows locked, deeper gesture/config branches partial: `4 Pass`, `0 Adapted Pass`, `4 Partial` | Focused reader-shell UI coverage plus adjacent-domain assertions | Fullscreen, swipe-mode, compare, and config-bridge coverage remain partial |
| [bridge](bridge/README.md) | Embedded note/document bridge paths locked, raw transport still partial: `1 Pass`, `1 Adapted Pass`, `5 Partial` | Focused My Notes/StudyPad regressions plus bridge guardrails | Raw bridge drift detection for method names, payloads, and async `callId` flows |

## Domain Reading Contract

Each domain directory is expected to answer the same five questions in order:

1. `contract.md`: what parity means for that domain
2. `dispositions.md`: what intentional iOS adaptations exist
3. `verification-matrix.md`: what is currently locked versus partial
4. `regression-report.md`: what validation evidence exists now
5. `guardrails.md`: what review rules apply to high-risk changes

`settings/` also carries:

- `baselines/` for machine-readable snapshots used by guardrails
- `archive/` for historical one-off analysis

## Automation Posture

The current parity automation model has three tiers.

### Tier 1: Machine-readable guardrails

Currently strongest in:

- [settings](settings/README.md)

Current mechanisms:

- `scripts/check_settings_localization_guardrails.py`
- committed snapshots in `docs/parity/settings/baselines/`
- CI integration in `.github/workflows/ios-ci.yml`

### Tier 2: Focused regression coverage

Currently strongest in:

- [sync](sync/README.md)
- [bookmarks](bookmarks/README.md)
- [search](search/README.md)
- [reading-plans](reading-plans/README.md)
- [reader](reader/README.md)
- [bridge](bridge/README.md)

Current mechanisms:

- focused `AndBibleTests` unit/integration subsets
- focused `AndBibleUITests` simulator workflows
- domain-specific regression reports documenting the rerunnable subsets

### Tier 3: Documentation guardrails

All current domains now have:

- explicit contract docs
- explicit dispositions
- explicit verification matrices
- explicit regression reports
- explicit maintenance guardrails

This is the baseline protection against silent parity drift when heavier
automation does not yet exist.

## Interpretation

The current repo is no longer in a “parity planning only” state.

It now has:

- a documented parity contract for every current domain
- explicit iOS adaptations for every current domain
- a verification snapshot for every current domain
- a documented automation and validation posture for every current domain

What it does not yet have is uniform machine-readable drift automation across
all domains. That is intentional. The current posture is:

- strongest automation in `settings/`
- strong focused regression evidence in `sync`, `bookmarks`, `search`, and
  `reading-plans`
- meaningful but still partial protection in `reader` and `bridge` where the
  remaining gaps are mostly boundary and protocol behaviors

## How To Use This Tree

When changing a parity-sensitive area:

1. start with this overview
2. open the target domain `README.md`
3. read `contract.md` and `dispositions.md`
4. check `verification-matrix.md` for current status
5. use `regression-report.md` and `guardrails.md` to choose the validation bar

If a change meaningfully shifts posture, update both:

- the domain docs
- this overview
