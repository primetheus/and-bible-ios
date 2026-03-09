// NightModeSettings.swift — Android night_mode_pref3 parity helpers

import Foundation

/// Night-mode preference values mirrored from Android `night_mode_pref3`.
public enum NightModeSetting: String, CaseIterable, Sendable {
    case system
    case automatic
    case manual
}

/// Resolves effective night-mode behavior from persisted preference values.
public enum NightModeSettingsResolver {
    /// Android gates "automatic" mode by ambient-light sensor availability.
    /// iOS app-level ambient light sensor access is not available.
    public static let autoModeAvailable = false

    /// Runtime-visible options, matching Android behavior when auto mode is unavailable.
    public static var availableModes: [NightModeSetting] {
        autoModeAvailable ? [.system, .automatic, .manual] : [.system, .manual]
    }

    /// Effective mode used at runtime.
    ///
    /// Android semantics:
    /// - `system` follows system appearance
    /// - `automatic` only takes effect when auto mode is available
    /// - all other states behave like manual mode
    public static func effectiveMode(from rawValue: String) -> NightModeSetting {
        if rawValue == NightModeSetting.system.rawValue {
            return .system
        }
        if rawValue == NightModeSetting.automatic.rawValue && autoModeAvailable {
            return .automatic
        }
        return .manual
    }

    /// Whether quick toggle controls should be enabled.
    ///
    /// Mirrors Android `ScreenSettings.manualMode` behavior:
    /// only raw value `manual` enables menu toggle.
    public static func isManualMode(rawValue: String) -> Bool {
        rawValue == NightModeSetting.manual.rawValue
    }

    /// Computes the effective night-mode boolean for rendering/bridge payloads.
    ///
    /// Automatic mode currently falls back to manual toggle state on iOS.
    public static func isNightMode(
        rawValue: String,
        manualNightMode: Bool,
        systemIsDark: Bool
    ) -> Bool {
        switch effectiveMode(from: rawValue) {
        case .system:
            return systemIsDark
        case .automatic, .manual:
            return manualNightMode
        }
    }
}
