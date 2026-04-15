import UIKit

public enum AndBibleWindowingControlStyleChoice {
    case automatic
    case minimal
}

/// Shared policy for whether iPadOS 26 window controls should use the minimal style.
public struct AndBibleWindowingControlPolicy {
    public static func shouldUseMinimalStyle(userInterfaceIdiom: UIUserInterfaceIdiom) -> Bool {
        userInterfaceIdiom == .pad
    }

    public static func preferredWindowingControlStyleChoice(
        userInterfaceIdiom: UIUserInterfaceIdiom
    ) -> AndBibleWindowingControlStyleChoice {
        shouldUseMinimalStyle(userInterfaceIdiom: userInterfaceIdiom) ? .minimal : .automatic
    }

    @available(iOS 26.0, *)
    public static func preferredWindowingControlStyle(
        userInterfaceIdiom: UIUserInterfaceIdiom
    ) -> UIWindowScene.WindowingControlStyle {
        switch preferredWindowingControlStyleChoice(userInterfaceIdiom: userInterfaceIdiom) {
        case .automatic:
            return .automatic
        case .minimal:
            return .minimal
        }
    }
}

/// Shared app delegate used to attach the window-scene delegate for iPadOS 26 window-control customization.
public final class AndBibleApplicationDelegate: NSObject, UIApplicationDelegate {
    public override init() {
        super.init()
    }

    public static func sceneConfiguration(sessionRole: UISceneSession.Role) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: nil, sessionRole: sessionRole)
        configuration.delegateClass = AndBibleWindowSceneDelegate.self
        return configuration
    }

    public func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        Self.sceneConfiguration(sessionRole: connectingSceneSession.role)
    }
}

/// Scene delegate that opts iPadOS 26 windows into the minimal system window-control style.
public final class AndBibleWindowSceneDelegate: NSObject, UIWindowSceneDelegate {
    public override init() {
        super.init()
    }

    @available(iOS 26.0, *)
    public static func preferredWindowingControlStyle(
        userInterfaceIdiom: UIUserInterfaceIdiom
    ) -> UIWindowScene.WindowingControlStyle {
        AndBibleWindowingControlPolicy.preferredWindowingControlStyle(userInterfaceIdiom: userInterfaceIdiom)
    }

    @available(iOS 26.0, *)
    public func preferredWindowingControlStyle(for windowScene: UIWindowScene) -> UIWindowScene.WindowingControlStyle {
        Self.preferredWindowingControlStyle(userInterfaceIdiom: windowScene.traitCollection.userInterfaceIdiom)
    }
}
