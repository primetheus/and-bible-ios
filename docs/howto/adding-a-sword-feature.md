# Adding A SWORD Feature

## 1. Find The Lowest Missing Layer

Check whether the functionality already exists in:
- `Sources/SwordKit/Sources/SwordKit`
- `Sources/SwordKit/CLibSword/include`

If the flat API is already exposed, add a Swift wrapper in `SwordKit` and stop there.

## 2. Add A C Adapter Only If Needed

If the needed libsword capability is not available to Swift yet:
- add the wrapper in `Sources/SwordKit/CLibSword`
- expose it through the public headers in `Sources/SwordKit/CLibSword/include`

`CLibSword` is the layer that bridges Swift and the prebuilt `libsword.xcframework` declared in `Package.swift:18-38`.

## 3. Wrap It In `SwordKit`

Put the Swift-facing API in the appropriate type, usually:
- `SwordManager`
- `SwordModule`
- a supporting data type like `BookInfo`

Keep SWORD-specific translation here rather than leaking C details upward.

## 4. Consume It From `BibleCore` Or `BibleUI`

Use `BibleCore` if the feature is domain logic or persistence-facing.
Use `BibleUI` if it is presentation-specific.

Examples:
- Dynamic canon support uses `SwordKit` metadata and is consumed by reader/navigation UI.
- Strong's search consumes SWORD module search capability but is surfaced through `SearchView` and `BibleReaderController`.

## 5. Add Regression Coverage

Preferred locations:
- `Sources/SwordKit/Tests/SwordKitTests` for low-level wrapper behavior
- `AndBibleTests/AndBibleTests.swift` for end-to-end app-facing regressions

If the feature broke in the UI before, add the regression at the highest realistic layer.
