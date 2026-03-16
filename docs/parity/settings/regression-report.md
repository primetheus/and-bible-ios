# SETPAR-702 Regression Report

Date: 2026-03-11

## Scope

Regression verification for settings parity work, Strong's search regression hardening, and CI/guardrail integration, using local simulator test execution and localization guardrail execution.

## Environment

- Repo: `and-bible-ios`
- Xcode scheme test target: `AndBibleTests.xctest` enabled (`AndBible.xcodeproj/xcshareddata/xcschemes/AndBible.xcscheme:26-54`)
- Simulator destination used: `platform=iOS Simulator,name=iPhone 17,OS=26.2`

## Executed Checks

### 1. SETPAR-603 localization guardrails (snapshot fallback path)

Command:

```bash
python3 scripts/check_settings_localization_guardrails.py --android-root /tmp/does-not-exist
```

Result: `PASS` (exit code `0`)

Observed output:

- `tree mismatches: 0`
- `ios_gap count: 0`
- `android source: snapshot:.../docs/parity/settings/baselines/localization-android.json`
- `keys checked: 58`
- `locales checked: 44`

Evidence:

- `scripts/check_settings_localization_guardrails.py`
- `docs/parity/settings/baselines/localization-android.json`
- `docs/parity/settings/baselines/localization-guardrail.json`

### 2. Xcode simulator unit test run (explicit result bundle)

Command:

```bash
mkdir -p .artifacts && \
xcodebuild \
  -project AndBible.xcodeproj \
  -scheme AndBible \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.2' \
  -derivedDataPath .derivedData \
  -resultBundlePath .artifacts/AndBibleTests-strongs-integration-20260311-2.xcresult \
  CODE_SIGNING_ALLOWED=NO \
  test
```

Result: `PASS` (`** TEST SUCCEEDED **`)

Observed test summary:

- `Executed 10 tests, with 0 failures (0 unexpected)`
- Test bundle: `AndBibleTests`
  - `testActionPreferencesUseActionShape`
  - `testAppPreferenceRegistryHasDefinitionForAllKeys`
  - `testCriticalPreferenceDefaultsMatchParityContract`
  - `testCSVSetEncodingAndDecodingRoundTrip`
  - `testStrongsQueryNormalizationHandlesLeadingZeroes`
  - `testStrongsQueryNormalizationAcceptsDecoratedInput`
  - `testParseVerseKeySupportsHumanReadableFormat`
  - `testParseVerseKeySupportsOsisFormat`
  - `testParseVerseKeySupportsOsisFormatWithSuffix`
  - `testStrongsSearchFindAllOccurrencesReturnsBundledKJVMatches`

Result bundle (generated during the run, not committed to git):

- `.artifacts/AndBibleTests-strongs-integration-20260311-2.xcresult`

### 3. Strong's find-all regression coverage

The test suite now includes a module-backed regression test for the exact Strong's search flow that had regressed:

- Query under test: `H02022`
- Execution path: bundled `KJV` SWORD module with Strong's metadata
- Assertion: find-all search returns at least one parsed verse hit

Evidence:

- `AndBibleTests/AndBibleTests.swift`
- `Sources/BibleUI/Sources/BibleUI/Search/StrongsSearchSupport.swift`
- `Sources/BibleUI/Sources/BibleUI/Search/SearchView.swift`

## CI Workflow Regression Verification

The CI workflow now includes the expected improvements and still runs guardrails + simulator tests:

- Job-level derived data / result bundle paths: `.github/workflows/ios-ci.yml:33-35`
- SwiftPM cache restore step: `.github/workflows/ios-ci.yml:40-49`
- Simulator test invocation with `-derivedDataPath` and `-resultBundlePath`: `.github/workflows/ios-ci.yml:147-158`
- `.xcresult` artifact upload: `.github/workflows/ios-ci.yml:160-167`

## Non-blocking Observations From Test Logs

- Simulator/runtime noise was observed (for example CoreSimulator/ExtensionKit and duplicate-class warnings from test-host loading). These warnings did not fail build/test execution in this run.
- `SearchView.swift` main-actor isolation warnings were removed by capturing view state before `Task.detached` and marking pure helper methods `nonisolated`.

## Outcome

- Regression suite status for this pass: `PASS`
- Guardrails status for this pass: `PASS`
- Verified outputs are consistent with current parity baseline docs and tests.

## Follow-up Inputs

See `docs/parity/settings/verification-matrix.md` for current functional parity status by key. Current remaining items are only documented platform divergences.
