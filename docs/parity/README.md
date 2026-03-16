# Parity Documentation

This subtree holds cross-platform parity material.

Use domain folders so each parity area can carry, as needed:

- source-of-truth contract
- documented iOS dispositions/divergences
- verification matrix
- regression evidence
- machine-readable baselines

Current maturity:

- `settings/` is the most complete domain and already includes guardrails,
  verification, regression evidence, and baselines
- `bridge/` now also includes a verification matrix, regression report, and
  explicit maintenance guardrails because protocol drift there is especially
  hard to catch after the fact
- `sync/` also now warrants explicit guardrails because backend keys, bootstrap
  markers, and patch/baseline semantics are easy to break without obvious local
  failures
- `bookmarks/` now also includes guardrails because label semantics, note
  persistence, and StudyPad/My Notes separation are easy to regress through
  seemingly local UI or model changes
- the remaining domains currently center on contract, dispositions,
  verification, and regression evidence, with room to add guardrails or
  baselines where they justify the maintenance cost

Current domains:

- [bridge/](bridge/README.md)
- [reader/](reader/README.md)
- [bookmarks/](bookmarks/README.md)
- [search/](search/README.md)
- [reading-plans/](reading-plans/README.md)
- [settings/](settings/README.md)
- [sync/](sync/README.md)
