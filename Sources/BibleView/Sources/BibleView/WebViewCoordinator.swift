// WebViewCoordinator.swift — WKWebView navigation delegate

import Foundation
import WebKit
import os.log
#if os(iOS)
import UIKit
#endif

private let logger = Logger(subsystem: "org.andbible", category: "WebViewCoordinator")

/// Coordinator for the WKWebView, handling navigation events and lifecycle.
public class WebViewCoordinator: NSObject, WKNavigationDelegate {
    let bridge: BibleBridge
    weak var webView: WKWebView?
    #if os(iOS)
    private var lastUserScrollOffsetY: CGFloat?
    private var didInstallSwipeRecognizers = false
    #endif

    init(bridge: BibleBridge) {
        self.bridge = bridge
        super.init()
    }

    // MARK: - WKNavigationDelegate

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        logger.info("BibleView page loaded successfully")
        #if os(iOS)
        lastUserScrollOffsetY = webView.scrollView.contentOffset.y
        #endif
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        logger.error("BibleView navigation failed: \(error.localizedDescription)")
    }

    public func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        // Allow local file navigation, intercept external and app-internal links
        if let url = navigationAction.request.url {
            if url.isFileURL {
                decisionHandler(.allow)
            } else if url.scheme == "osis" || url.scheme == "multi" {
                // Cross-reference links: osis://?osis=Matt.1.1&v11n=KJV
                bridge.delegate?.bridge(bridge, openExternalLink: url.absoluteString)
                decisionHandler(.cancel)
            } else if url.scheme == "ab-w" {
                // ab-w:// links from raw HTML <a> tags (e.g. linkified Strong's refs).
                // Vue.js components use navigateLink() → postMessage, but raw <a href>
                // tags in v-html content trigger navigation directly.
                logger.info("decidePolicyFor: intercepted ab-w:// navigation: \(url.absoluteString)")
                bridge.delegate?.bridge(bridge, openExternalLink: url.absoluteString)
                decisionHandler(.cancel)
            } else if url.scheme == "ab-find-all" {
                // "Find all occurrences" links from FeaturesLink.vue
                bridge.delegate?.bridge(bridge, openExternalLink: url.absoluteString)
                decisionHandler(.cancel)
            } else if url.scheme == "https" || url.scheme == "http" {
                // External links through bridge delegate
                bridge.delegate?.bridge(bridge, openExternalLink: url.absoluteString)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }

    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        logger.error("BibleView provisional navigation failed: \(error.localizedDescription)")
    }
}

#if os(iOS)
extension WebViewCoordinator: UIScrollViewDelegate, UIGestureRecognizerDelegate {
    func installSwipeRecognizersIfNeeded(on webView: WKWebView) {
        guard !didInstallSwipeRecognizers else { return }
        didInstallSwipeRecognizers = true

        let left = UISwipeGestureRecognizer(target: self, action: #selector(handleHorizontalSwipe(_:)))
        left.direction = .left
        left.cancelsTouchesInView = false
        left.delegate = self

        let right = UISwipeGestureRecognizer(target: self, action: #selector(handleHorizontalSwipe(_:)))
        right.direction = .right
        right.cancelsTouchesInView = false
        right.delegate = self

        webView.addGestureRecognizer(left)
        webView.addGestureRecognizer(right)
    }

    @objc private func handleHorizontalSwipe(_ recognizer: UISwipeGestureRecognizer) {
        switch recognizer.direction {
        case .left:
            bridge.onNativeHorizontalSwipe?(.left)
        case .right:
            bridge.onNativeHorizontalSwipe?(.right)
        default:
            break
        }
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastUserScrollOffsetY = scrollView.contentOffset.y
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        guard scrollView.isTracking || scrollView.isDragging || scrollView.isDecelerating else {
            lastUserScrollOffsetY = offsetY
            return
        }
        guard let previous = lastUserScrollOffsetY else {
            lastUserScrollOffsetY = offsetY
            return
        }

        let delta = offsetY - previous
        if delta != 0 {
            bridge.onNativeScrollDeltaY?(Double(delta))
        }
        lastUserScrollOffsetY = offsetY
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        lastUserScrollOffsetY = scrollView.contentOffset.y
    }
}
#endif
