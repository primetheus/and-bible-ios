import XCTest

/**
 UI smoke tests for the core iPhone navigation shell.

 Data dependencies:
 - launches the production AndBible app target under XCUITest
 - relies on stable accessibility identifiers exposed by the reader overflow menu and settings form

 Side effects:
 - boots the app in a simulator-hosted UI automation session
 - opens the reader overflow menu and drives settings navigation

 Failure modes:
 - fails when the app no longer reaches the reader shell on launch
 - fails when the documented accessibility identifiers drift without coordinated test updates

 Concurrency:
 - runs on XCTest's serialized UI automation thread
 */
final class AndBibleUITests: XCTestCase {
    /**
     Configures each UI test for fail-fast execution.
     *
     * - Side effects:
     *   - disables XCTest's continue-after-failure behavior for the current test method
     * - Failure modes: This override cannot fail.
     */
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /**
     Verifies that settings can be opened from the reader shell.
     *
     * - Side effects:
     *   - launches the app with the calculator gate disabled for test determinism
     *   - opens the reader overflow menu and pushes the settings screen
     * - Failure modes:
     *   - fails if settings cannot be reached from the reader shell
     *   - fails if the settings form or critical navigation rows are absent after navigation completes
     */
    func testSettingsScreenShowsPrimaryNavigationRows() {
        let app = makeApp()
        app.launch()

        let moreMenuButton = requireElement("readerMoreMenuButton", in: app)
        moreMenuButton.tap()
        requireElement("readerOpenSettingsAction", in: app, timeout: 5).tap()

        XCTAssertTrue(requireElement("settingsForm", in: app, timeout: 10).exists)
    }

    /**
     Verifies that reading plans can be opened from the reader shell.
     *
     * - Side effects:
     *   - launches the app with the calculator gate disabled for test determinism
     *   - opens the reader overflow menu and pushes the reading-plan screen
     * - Failure modes:
     *   - fails if the reading-plans action is missing from the reader menu
     *   - fails if the reading-plan list screen does not render after navigation completes
     */
    func testReadingPlansScreenOpensFromReaderMenu() {
        let app = makeApp()
        app.launch()

        let moreMenuButton = requireElement("readerMoreMenuButton", in: app)
        moreMenuButton.tap()
        requireElement("readerOpenReadingPlansAction", in: app, timeout: 5).tap()

        XCTAssertTrue(requireElement("readingPlanListScreen", in: app, timeout: 10).exists)
    }

    /**
     Verifies that the downloads browser can be opened from the reader shell.
     *
     * - Side effects:
     *   - launches the app with the calculator gate disabled for test determinism
     *   - opens the reader overflow menu and pushes the downloads browser
     * - Failure modes:
     *   - fails if the downloads action is missing from the reader menu
     *   - fails if the downloads browser screen does not render after navigation completes
     */
    func testDownloadsScreenOpensFromReaderMenu() {
        let app = makeApp()
        app.launch()

        let moreMenuButton = requireElement("readerMoreMenuButton", in: app)
        moreMenuButton.tap()
        requireElement("readerOpenDownloadsAction", in: app, timeout: 5).tap()

        XCTAssertTrue(requireElement("moduleBrowserScreen", in: app, timeout: 10).exists)
    }

    /**
     Verifies that the workspace selector can be opened from the reader shell.
     *
     * - Side effects:
     *   - launches the app with the calculator gate disabled for test determinism
     *   - opens the reader overflow menu and pushes the workspace selector
     * - Failure modes:
     *   - fails if the workspaces action is missing from the reader menu
     *   - fails if the workspace selector screen does not render after navigation completes
     */
    func testWorkspacesScreenOpensFromReaderMenu() {
        let app = makeApp()
        app.launch()

        let moreMenuButton = requireElement("readerMoreMenuButton", in: app)
        moreMenuButton.tap()
        requireElement("readerOpenWorkspacesAction", in: app, timeout: 5).tap()

        XCTAssertTrue(requireElement("workspaceSelectorScreen", in: app, timeout: 10).exists)
    }

    /**
     Verifies that the bookmark list can be opened from the reader shell.
     *
     * - Side effects:
     *   - launches the app with the calculator gate disabled for test determinism
     *   - opens the reader overflow menu and pushes the bookmark list
     * - Failure modes:
     *   - fails if the bookmarks action is missing from the reader menu
     *   - fails if the bookmark list screen does not render after navigation completes
     */
    func testBookmarksScreenOpensFromReaderMenu() {
        let app = makeApp()
        app.launch()

        let moreMenuButton = requireElement("readerMoreMenuButton", in: app)
        moreMenuButton.tap()
        requireElement("readerOpenBookmarksAction", in: app, timeout: 5).tap()

        XCTAssertTrue(requireElement("bookmarkListScreen", in: app, timeout: 10).exists)
    }

    /**
     Verifies that the about screen can be opened from the reader shell.
     *
     * - Side effects:
     *   - launches the app with the calculator gate disabled for test determinism
     *   - opens the reader overflow menu and pushes the about screen
     * - Failure modes:
     *   - fails if the about action is missing from the reader menu
     *   - fails if the about screen does not render after navigation completes
     */
    func testAboutScreenOpensFromReaderMenu() {
        let app = makeApp()
        app.launch()

        let moreMenuButton = requireElement("readerMoreMenuButton", in: app)
        moreMenuButton.tap()
        requireElement("readerOpenAboutAction", in: app, timeout: 5).tap()

        XCTAssertTrue(requireElement("aboutScreen", in: app, timeout: 10).exists)
    }

    /**
     Verifies that the downloads browser can be opened from Settings.
     *
     * - Side effects:
     *   - launches the app directly into Settings with the downloads row pre-scrolled into view
     *   - opens the downloads browser from the settings screen
     * - Failure modes:
     *   - fails if the Settings downloads link is missing or never becomes hittable
     *   - fails if the downloads browser screen does not render after navigation completes
     */
    func testSettingsDownloadsLinkOpensDownloadsBrowser() {
        let app = makeApp(settingsTarget: "settingsDownloadsLink")
        app.launch()

        openSettings(in: app, launchedDirectly: true)
        tapSettingsElement("settingsDownloadsLink", in: app)

        XCTAssertTrue(requireElement("moduleBrowserScreen", in: app, timeout: 10).exists)
    }

    /**
     Verifies that the import/export screen can be opened from Settings.
     *
     * - Side effects:
     *   - launches the app directly into Settings with the import/export row pre-scrolled into view
     *   - opens the import/export screen from Settings
     * - Failure modes:
     *   - fails if the Settings import/export link is missing or never becomes hittable
     *   - fails if the import/export screen does not render after navigation completes
     */
    func testSettingsImportExportLinkOpensImportExportScreen() {
        let app = makeApp(settingsTarget: "settingsImportExportLink")
        app.launch()

        openSettings(in: app, launchedDirectly: true)
        tapSettingsElement("settingsImportExportLink", in: app)

        XCTAssertTrue(requireElement("importExportScreen", in: app, timeout: 10).exists)
    }

    /**
     Verifies that the full-backup export action drives Import and Export into share-sheet presentation.
     *
     * - Side effects:
     *   - launches the app directly into Import and Export
     *   - triggers a full-backup export, which writes a temporary file and requests share-sheet
     *     presentation
     * - Failure modes:
     *   - fails if the full-backup action is missing from the Import and Export screen
     *   - fails if the Import and Export screen never reports the share-sheet-presented state after
     *     export completes
     */
    func testSettingsImportExportFullBackupPresentsShareSheet() {
        let app = makeApp(openImportExportOnLaunch: true)
        app.launch()

        let importExportScreen = openImportExport(in: app, launchedDirectly: true)
        XCTAssertTrue(importExportScreen.exists)

        let fullBackupButton = requireElement("importExportFullBackupButton", in: app, timeout: 10)
        fullBackupButton.tap()

        let valuePredicate = NSPredicate(format: "value == %@", "shareSheetPresented")
        expectation(for: valuePredicate, evaluatedWith: importExportScreen)
        waitForExpectations(timeout: 15)
    }

    /**
     Verifies that the import action drives Import and Export into file-picker presentation.
     *
     * - Side effects:
     *   - launches the app directly into Import and Export
     *   - triggers the backup import action, which requests document-picker presentation
     * - Failure modes:
     *   - fails if the import action is missing from the Import and Export screen
     *   - fails if the Import and Export screen never reports the import-picker-presented state
     */
    func testSettingsImportExportImportPresentsFilePickerState() {
        let app = makeApp(openImportExportOnLaunch: true)
        app.launch()

        let importExportScreen = openImportExport(in: app, launchedDirectly: true)
        XCTAssertTrue(importExportScreen.exists)

        let importButton = requireElement("importExportImportButton", in: app, timeout: 10)
        importButton.tap()

        let valuePredicate = NSPredicate(format: "value == %@", "importPickerPresented")
        expectation(for: valuePredicate, evaluatedWith: importExportScreen)
        waitForExpectations(timeout: 15)
    }

    /**
     Verifies that the label manager can be opened from Settings.
     *
     * - Side effects:
     *   - launches the app directly into Settings with the labels row pre-scrolled into view
     *   - opens the label manager from Settings
     * - Failure modes:
     *   - fails if the Settings labels link is missing or never becomes hittable
     *   - fails if the label manager screen does not render after navigation completes
     */
    func testSettingsLabelsLinkOpensLabelManager() {
        let app = makeApp(settingsTarget: "settingsLabelsLink")
        app.launch()

        XCTAssertTrue(openLabelManager(in: app).exists)
    }

    /**
     Verifies that labels can be created, renamed, and deleted from the label manager.
     *
     * - Side effects:
     *   - launches the app directly into the label manager
     *   - creates one new label, renames it through the edit sheet, and deletes it via swipe
     *     actions
     * - Failure modes:
     *   - fails if the create alert, edit sheet, or delete swipe action cannot be reached through
     *     the label manager UI
     *   - fails if the created or renamed label row never appears, or if the deleted row remains
     *     visible after deletion
     */
    func testLabelManagerCreateRenameDeleteFlow() {
        let app = makeApp(openLabelManagerOnLaunch: true)
        let originalName = uniqueLabelName(prefix: "UITest Label")
        let renamedName = uniqueLabelName(prefix: "UITest Renamed Label")
        app.launch()

        XCTAssertTrue(openLabelManager(in: app, launchedDirectly: true).exists)

        requireElement("labelManagerAddButton", in: app, timeout: 10).tap()
        let newLabelAlert = app.alerts.firstMatch
        XCTAssertTrue(newLabelAlert.waitForExistence(timeout: 10))
        let newLabelField = newLabelAlert.textFields.firstMatch
        XCTAssertTrue(newLabelField.waitForExistence(timeout: 10))
        newLabelField.tap()
        newLabelField.typeText(originalName)
        let createButton = newLabelAlert.buttons["Create"].firstMatch
        XCTAssertTrue(createButton.waitForExistence(timeout: 10))
        createButton.tap()

        let originalRow = requireLabelRow(named: originalName, in: app, timeout: 10)
        originalRow.tap()

        XCTAssertTrue(requireElement("labelEditScreen", in: app, timeout: 10).exists)
        let labelEditNameField = requireElement("labelEditNameField", in: app, timeout: 10)
        replaceText(in: labelEditNameField, with: renamedName)
        requireElement("labelEditDoneButton", in: app, timeout: 10).tap()

        let renamedRow = requireLabelRow(named: renamedName, in: app, timeout: 10)
        XCTAssertTrue(renamedRow.exists)
        XCTAssertFalse(labelRow(named: originalName, in: app).exists)

        renamedRow.swipeLeft()
        requireElement("labelManagerDeleteAction", in: app, timeout: 10).tap()

        let deletedPredicate = NSPredicate(format: "exists == false")
        expectation(for: deletedPredicate, evaluatedWith: labelRow(named: renamedName, in: app))
        waitForExpectations(timeout: 10)
    }

    /**
     Verifies that the sync settings screen can be opened from Settings.
     *
     * - Side effects:
     *   - launches the app directly into Settings with the sync row pre-scrolled into view
     *   - opens sync settings from the settings screen
     * - Failure modes:
     *   - fails if the Settings sync link is missing or never becomes hittable
     *   - fails if the sync settings screen does not render after navigation completes
     */
    func testSettingsSyncLinkOpensSyncSettings() {
        let app = makeApp(settingsTarget: "settingsSyncLink")
        app.launch()

        openSettings(in: app, launchedDirectly: true)
        tapSettingsElement("settingsSyncLink", in: app)

        XCTAssertTrue(requireElement("syncSettingsScreen", in: app, timeout: 10).exists)
    }

    /**
     Verifies that the text-display editor can be opened from Settings.
     *
     * - Side effects:
     *   - launches the app directly into Settings with the text-display row pre-scrolled into view
     *   - opens text-display settings from the settings screen
     * - Failure modes:
     *   - fails if the Settings text-display link is missing or never becomes hittable
     *   - fails if the text-display settings screen does not render after navigation completes
     */
    func testSettingsTextDisplayLinkOpensTextDisplayEditor() {
        let app = makeApp(settingsTarget: "settingsTextDisplayLink")
        app.launch()

        openSettings(in: app, launchedDirectly: true)
        tapSettingsElement("settingsTextDisplayLink", in: app)

        XCTAssertTrue(requireElement("textDisplaySettingsScreen", in: app, timeout: 10).exists)
    }

    /**
     Verifies that the color editor can be opened from Settings.
     *
     * - Side effects:
     *   - launches the app directly into Settings with the colors row pre-scrolled into view
     *   - opens color settings from the settings screen
     * - Failure modes:
     *   - fails if the Settings colors link is missing or never becomes hittable
     *   - fails if the color settings screen does not render after navigation completes
     */
    func testSettingsColorsLinkOpensColorEditor() {
        let app = makeApp(settingsTarget: "settingsColorsLink")
        app.launch()

        openSettings(in: app, launchedDirectly: true)
        tapSettingsElement("settingsColorsLink", in: app)

        XCTAssertTrue(requireElement("colorSettingsScreen", in: app, timeout: 10).exists)
    }

    /**
     Builds the configured XCUIApplication instance used by each smoke test.
     *
     * - Parameters:
     *   - settingsTarget: Optional settings-row identifier that the app should open and pre-scroll
     *     into view on launch.
     *   - openImportExportOnLaunch: Whether the app should present Import and Export immediately on
     *     launch.
     *   - openLabelManagerOnLaunch: Whether the app should present Label Manager immediately on
     *     launch.
     * - Returns: App handle configured with deterministic launch arguments for the smoke suite.
     * - Side effects:
     *   - appends a launch argument that disables the discrete-mode calculator gate during UI tests
     *   - when `settingsTarget` is supplied, configures the app to present Settings immediately and
     *     scroll the requested row into view
     *   - when `openImportExportOnLaunch` is `true`, configures the app to present Import and
     *     Export immediately after the reader hydrates
     *   - when `openLabelManagerOnLaunch` is `true`, configures the app to present Label Manager
     *     immediately after the reader hydrates
     * - Failure modes: This helper cannot fail.
     */
    private func makeApp(
        settingsTarget: String? = nil,
        openImportExportOnLaunch: Bool = false,
        openLabelManagerOnLaunch: Bool = false
    ) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments += ["UITEST_DISABLE_CALCULATOR_GATE"]
        if let settingsTarget {
            app.launchArguments += ["UITEST_OPEN_SETTINGS"]
            app.launchEnvironment["UITEST_SETTINGS_SCROLL_TARGET"] = settingsTarget
        }
        if openImportExportOnLaunch {
            app.launchArguments += ["UITEST_OPEN_IMPORT_EXPORT"]
        }
        if openLabelManagerOnLaunch {
            app.launchArguments += ["UITEST_OPEN_LABEL_MANAGER"]
        }
        return app
    }

    /**
     Opens Label Manager either from Settings navigation or from a direct test-only launch path.
     *
     * - Parameters:
     *   - app: Running application under test.
     *   - launchedDirectly: Whether the app was launched straight into the Label Manager sheet.
     * - Returns: The root accessibility-identified Label Manager screen element.
     * - Side effects:
     *   - when `launchedDirectly` is `false`, opens Settings and pushes the Label Manager screen
     *   - when `launchedDirectly` is `true`, waits for the direct-launch Label Manager sheet to
     *     render
     * - Failure modes:
     *   - fails when the Label Manager screen never appears
     */
    private func openLabelManager(
        in app: XCUIApplication,
        launchedDirectly: Bool = false
    ) -> XCUIElement {
        if !launchedDirectly {
            openSettings(
                in: app,
                launchedDirectly: app.launchArguments.contains("UITEST_OPEN_SETTINGS")
            )
            tapSettingsElement("settingsLabelsLink", in: app)
        }
        return requireElement("labelManagerScreen", in: app, timeout: 10)
    }

    /**
     Opens Import and Export either from Settings navigation or from a direct test-only launch path.
     *
     * - Parameters:
     *   - app: Running application under test.
     *   - launchedDirectly: Whether the app was launched straight into the Import and Export sheet.
     * - Returns: The root accessibility-identified Import and Export screen element.
     * - Side effects:
     *   - when `launchedDirectly` is `false`, opens Settings and pushes the Import and Export screen
     *   - when `launchedDirectly` is `true`, waits for the direct-launch Import and Export sheet to
     *     render
     * - Failure modes:
     *   - fails when the Import and Export screen never appears
     */
    private func openImportExport(
        in app: XCUIApplication,
        launchedDirectly: Bool = false
    ) -> XCUIElement {
        if !launchedDirectly {
            openSettings(in: app)
            tapSettingsElement("settingsImportExportLink", in: app)
        }
        return requireElement("importExportScreen", in: app, timeout: 10)
    }

    /**
     Opens Settings from the reader overflow menu.
     *
     * - Parameters:
     *   - app: Running application under test.
     *   - launchedDirectly: Whether the app was launched straight into the settings sheet.
     * - Side effects:
     *   - when `launchedDirectly` is `false`, opens the reader overflow menu and pushes the
     *     Settings screen onto the navigation stack
     *   - dismisses the language restart alert only when it is already present after Settings loads
     * - Failure modes:
     *   - fails when the reader overflow menu or Settings action cannot be found for non-direct
     *     launches
     *   - fails when the settings form never appears
     */
    private func openSettings(in app: XCUIApplication, launchedDirectly: Bool = false) {
        if !launchedDirectly {
            let moreMenuButton = requireElement("readerMoreMenuButton", in: app)
            moreMenuButton.tap()
            requireElement("readerOpenSettingsAction", in: app, timeout: 5).tap()
        }
        XCTAssertTrue(requireElement("settingsForm", in: app, timeout: 10).exists)
        let okButton = app.buttons["OK"]
        if okButton.exists {
            okButton.tap()
            XCTAssertTrue(requireElement("settingsForm", in: app, timeout: 10).exists)
        }
    }

    /**
     Waits for an accessibility-identified element and records a precise failure when it never appears.
     *
     * - Parameters:
     *   - identifier: Accessibility identifier expected to appear in the UI hierarchy.
     *   - app: Running application under test.
     *   - timeout: Maximum number of seconds to wait before failing.
     *   - file: Source file used for XCTest failure attribution.
     *   - line: Source line used for XCTest failure attribution.
     * - Returns: The first matching UI element for the requested accessibility identifier.
     * - Side effects:
     *   - queries the live XCUI hierarchy repeatedly until the timeout expires
     *   - records an XCTest assertion failure when no matching element appears in time
     * - Failure modes:
     *   - returns the unresolved query result after recording a failure when the identifier never appears
     */
    private func requireElement(
        _ identifier: String,
        in app: XCUIApplication,
        timeout: TimeInterval = 10,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> XCUIElement {
        let element = app.descendants(matching: .any)[identifier].firstMatch
        XCTAssertTrue(
            element.waitForExistence(timeout: timeout),
            "Expected element '\(identifier)' to exist within \(timeout) seconds.",
            file: file,
            line: line
        )
        return element
    }

    /**
     Waits for a pre-scrolled settings row to become hittable, then taps it.
     *
     * - Parameters:
     *   - identifier: Accessibility identifier of the target settings row.
     *   - app: Running application under test.
     *   - timeout: Maximum number of seconds to wait for the row to become hittable.
     *   - file: Source file used for XCTest failure attribution.
     *   - line: Source line used for XCTest failure attribution.
     * - Side effects:
     *   - waits for the requested settings row to resolve and become hittable
     *   - taps the target row once it becomes hittable
     * - Failure modes:
     *   - records an XCTest failure if the row never appears or never becomes hittable within the
     *     allotted timeout
     */
    private func tapSettingsElement(
        _ identifier: String,
        in app: XCUIApplication,
        timeout: TimeInterval = 10,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let element = requireElement(identifier, in: app, timeout: timeout, file: file, line: line)
        let hittablePredicate = NSPredicate(format: "hittable == true")
        let expectation = XCTNSPredicateExpectation(predicate: hittablePredicate, object: element)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        XCTAssertEqual(
            result,
            .completed,
            "Expected element '\(identifier)' to become hittable within \(timeout) seconds.",
            file: file,
            line: line
        )
        element.tap()
    }

    /**
     Resolves one label row by its accessibility label.
     *
     * - Parameters:
     *   - name: User-visible label name expected on the row.
     *   - app: Running application under test.
     * - Returns: The first matching Label Manager row button for the requested label name.
     * - Side effects:
     *   - queries the live accessibility hierarchy for a label-manager row whose label matches
     *     `name`
     * - Failure modes:
     *   - returns an unresolved query when no matching row currently exists
     */
    private func labelRow(named name: String, in app: XCUIApplication) -> XCUIElement {
        let predicate = NSPredicate(format: "label == %@", name)
        return app.buttons
            .matching(identifier: "labelManagerRowButton")
            .matching(predicate)
            .firstMatch
    }

    /**
     Waits for a label row to appear and records a precise failure if it does not.
     *
     * - Parameters:
     *   - name: User-visible label name expected on the row.
     *   - app: Running application under test.
     *   - timeout: Maximum number of seconds to wait before failing.
     *   - file: Source file used for XCTest failure attribution.
     *   - line: Source line used for XCTest failure attribution.
     * - Returns: The resolved label-row UI element.
     * - Side effects:
     *   - polls the live accessibility hierarchy until the requested row exists or the timeout
     *     expires
     * - Failure modes:
     *   - records an XCTest failure if the row never appears within the requested timeout
     */
    private func requireLabelRow(
        named name: String,
        in app: XCUIApplication,
        timeout: TimeInterval = 10,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> XCUIElement {
        let element = labelRow(named: name, in: app)
        XCTAssertTrue(
            element.waitForExistence(timeout: timeout),
            "Expected label row '\(name)' to exist within \(timeout) seconds.",
            file: file,
            line: line
        )
        return element
    }

    /**
     Replaces the entire contents of one text field with a new string.
     *
     * - Parameters:
     *   - element: Text field to overwrite.
     *   - text: Replacement text that should become the field's entire value.
     * - Side effects:
     *   - focuses the field, emits delete keystrokes for the current value, and types the
     *     replacement text through XCTest's software keyboard bridge
     * - Failure modes:
     *   - if the field reports a non-string value, the helper falls back to appending `text`
     *     instead of first deleting existing content
     */
    private func replaceText(in element: XCUIElement, with text: String) {
        element.tap()
        if let existingText = element.value as? String {
            let deleteSequence = String(repeating: XCUIKeyboardKey.delete.rawValue, count: existingText.count)
            element.typeText(deleteSequence + text)
        } else {
            element.typeText(text)
        }
    }

    /**
     Builds a unique label name for tests that create and later remove labels.
     *
     * - Parameter prefix: Human-readable prefix to keep XCTest failures understandable.
     * - Returns: One unique label name derived from `prefix` plus a short UUID suffix.
     * - Side effects: none.
     * - Failure modes: This helper cannot fail.
     */
    private func uniqueLabelName(prefix: String) -> String {
        "\(prefix) \(String(UUID().uuidString.prefix(8)))"
    }
}
