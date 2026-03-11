# Working With Vue.js

The web client lives in:
- `bibleview-js/`

The packaged bundle is loaded by `BibleWebView` from SwiftPM resources:
- `Sources/BibleView/Sources/BibleView/BibleWebView.swift:279-301`

## Useful Commands

```bash
cd bibleview-js
npm run type-check
npm run test:ci
npm run build-debug
```

Available scripts come from:
- `bibleview-js/package.json`

## Native Bridge Assumption

The client mostly talks to native through `window.android.*` calls.
On iOS, `BibleWebView` injects a proxy that forwards those calls to `window.webkit.messageHandlers.bibleView`.

Relevant code:
- `Sources/BibleView/Sources/BibleView/BibleWebView.swift:154-176`

## Logging

`console.log`, `console.warn`, and `console.error` are forwarded back to native logging through the `jsLog` bridge message.

Relevant code:
- `Sources/BibleView/Sources/BibleView/BibleWebView.swift:189-227`

## When You Change Client Contracts

If you change:
- a bridge method name
- a payload shape
- a native event name
- `set_config` expectations

then update both sides in the same change:
- Vue.js code in `bibleview-js/src/`
- Swift bridge types/dispatcher in `Sources/BibleView/Sources/BibleView/`
- controller emit/response code in `Sources/BibleUI/Sources/BibleUI/Bible/`
