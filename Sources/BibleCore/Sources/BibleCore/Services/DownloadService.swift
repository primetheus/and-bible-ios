// DownloadService.swift — Module download and installation

import Foundation
import Observation
import SwordKit

/// Download progress information.
public struct DownloadProgress: Sendable {
    /// Module abbreviation being downloaded.
    public let moduleName: String
    /// Bytes downloaded so far, when known.
    public let bytesDownloaded: Int64
    /// Total expected byte count, when known.
    public let totalBytes: Int64?
    /// Whether the download/install operation has finished.
    public let isComplete: Bool
    /// User-visible error message for failed operations, when available.
    public let error: String?

    /// Fractional completion in the range `0...1` when `totalBytes` is known.
    public var fractionComplete: Double {
        guard let total = totalBytes, total > 0 else { return 0 }
        return Double(bytesDownloaded) / Double(total)
    }
}

/**
 Manages remote module catalog refresh, installation, and uninstall flows.

 This service is a thin BibleCore wrapper over SwordKit's `InstallManager`.
 Its responsibilities are:
 - expose remote sources and remote module catalogs to the UI
 - track coarse in-memory install state in `activeDownloads`
 - refresh the active `SwordManager` after successful installs/uninstalls so future module
   lookups see the new module set

 Detailed download transport, catalog caching, and lower-level install behavior remain in
 `InstallManager` and SwordKit's repository layer.
 */
@Observable
public final class DownloadService {
    private let swordManager: SwordManager
    private let installManager: InstallManager

    /// Currently known download/install states keyed by module abbreviation.
    public private(set) var activeDownloads: [String: DownloadProgress] = [:]

    /**
     Creates a download service.
     - Parameters:
       - swordManager: Active SWORD manager whose module list should be refreshed after changes.
       - installManager: SwordKit installer used for catalog and install operations.
     */
    public init(swordManager: SwordManager, installManager: InstallManager) {
        self.swordManager = swordManager
        self.installManager = installManager
    }

    /**
     Refreshes the remote catalog for a configured source.
     - Parameter sourceName: Source/repository name such as `CrossWire`.
     - Returns: `true` on success, otherwise `false`.
     */
    public func refreshSource(_ sourceName: String) async -> Bool {
        await withCheckedContinuation { continuation in
            let result = installManager.refreshSource(sourceName)
            continuation.resume(returning: result)
        }
    }

    /**
     Lists modules available from a remote source with optional category/language filters.
     - Parameters:
       - sourceName: Source/repository name to query.
       - category: Optional module-category filter.
       - language: Optional language-code filter.
     - Returns: Matching remote modules.
     */
    public func availableModules(
        from sourceName: String,
        category: ModuleCategory? = nil,
        language: String? = nil
    ) -> [RemoteModuleInfo] {
        var modules = installManager.availableModules(from: sourceName)

        if let category {
            modules = modules.filter { $0.category == category }
        }
        if let language {
            modules = modules.filter { $0.language == language }
        }

        return modules
    }

    /**
     Installs a module from a remote source into the active `SwordManager`.
     - Parameters:
       - moduleName: Module abbreviation to install.
       - sourceName: Remote source to install from.
     - Returns: `true` when installation succeeds, otherwise `false`.
     - Note: Progress reporting is currently coarse-grained. `activeDownloads` records queued and
       completed states, but byte-level updates are not yet surfaced through this service.
     */
    public func install(moduleName: String, from sourceName: String) async -> Bool {
        activeDownloads[moduleName] = DownloadProgress(
            moduleName: moduleName,
            bytesDownloaded: 0,
            totalBytes: nil,
            isComplete: false,
            error: nil
        )

        let success = await withCheckedContinuation { continuation in
            let result = installManager.install(
                moduleName: moduleName,
                from: sourceName,
                into: swordManager
            )
            continuation.resume(returning: result)
        }

        activeDownloads[moduleName] = DownloadProgress(
            moduleName: moduleName,
            bytesDownloaded: 0,
            totalBytes: nil,
            isComplete: true,
            error: success ? nil : "Installation failed"
        )

        if success {
            swordManager.refresh()
        }

        return success
    }

    /**
     Uninstalls a module from the active `SwordManager`.
     - Parameter moduleName: Module abbreviation to uninstall.
     - Returns: `true` when uninstallation succeeds, otherwise `false`.
     */
    public func uninstall(moduleName: String) -> Bool {
        let success = installManager.uninstall(moduleName: moduleName, from: swordManager)
        if success {
            swordManager.refresh()
        }
        return success
    }

    /**
     Lists configured remote sources exposed by the underlying installer.
     - Returns: Remote repository metadata rows.
     */
    public func remoteSources() -> [RemoteSource] {
        installManager.remoteSources()
    }
}
