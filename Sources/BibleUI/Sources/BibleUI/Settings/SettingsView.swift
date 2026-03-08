// SettingsView.swift — App settings

import SwiftUI
import SwiftData
import BibleCore
import SwordKit
#if os(iOS)
import UIKit
#endif

/// Main settings screen for the app.
public struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var displaySettings: TextDisplaySettings
    @Binding var nightMode: Bool
    var onSettingsChanged: (() -> Void)?

    @State private var strongsGreekDictionaries: [ModuleInfo] = []
    @State private var strongsHebrewDictionaries: [ModuleInfo] = []
    @State private var robinsonMorphologyDictionaries: [ModuleInfo] = []
    @State private var wordLookupDictionaries: [ModuleInfo] = []
    @State private var selectedStrongsGreekDictionaryNames: Set<String> = []
    @State private var selectedStrongsHebrewDictionaryNames: Set<String> = []
    @State private var selectedRobinsonMorphologyDictionaryNames: Set<String> = []
    @State private var disabledWordLookupDictionaryNames: Set<String> = []
    @AppStorage(AppPreferenceKey.discreteMode.rawValue)
    private var discreteMode = AppPreferenceRegistry.boolDefault(for: .discreteMode) ?? false
    @AppStorage(AppPreferenceKey.showCalculator.rawValue)
    private var showCalculator = AppPreferenceRegistry.boolDefault(for: .showCalculator) ?? false
    @AppStorage(AppPreferenceKey.calculatorPin.rawValue)
    private var calculatorPin = AppPreferenceRegistry.stringDefault(for: .calculatorPin) ?? "1234"
    @State private var openLinksInSpecialWindow =
        AppPreferenceRegistry.boolDefault(for: .openLinksInSpecialWindowPref) ?? true
    @State private var monochromeMode = AppPreferenceRegistry.boolDefault(for: .monochromeMode) ?? false
    @State private var disableAnimations = AppPreferenceRegistry.boolDefault(for: .disableAnimations) ?? false
    @State private var disableClickToEdit = AppPreferenceRegistry.boolDefault(for: .disableClickToEdit) ?? false
    @State private var showActiveWindowIndicator =
        AppPreferenceRegistry.boolDefault(for: .showActiveWindowIndicator) ?? true
    @State private var showErrorBox = AppPreferenceRegistry.boolDefault(for: .showErrorBox) ?? false
    @State private var fontSizeMultiplier = AppPreferenceRegistry.intDefault(for: .fontSizeMultiplier) ?? 100
    @State private var navigateToVerse = AppPreferenceRegistry.boolDefault(for: .navigateToVersePref) ?? false
    @State private var screenKeepOn = AppPreferenceRegistry.boolDefault(for: .screenKeepOnPref) ?? false
    @State private var doubleTapToFullscreen =
        AppPreferenceRegistry.boolDefault(for: .doubleTapToFullscreen) ?? true
    @State private var autoFullscreen = AppPreferenceRegistry.boolDefault(for: .autoFullscreenPref) ?? false
    @State private var selectedLanguage: String = ""
    @State private var showRestartAlert = false
    @State private var showDiscreteHelp = false

    /// Available languages with their .lproj directories in the app bundle.
    private static let availableLanguages: [(code: String, name: String)] = {
        let codes = [
            "af", "ar", "az", "bg", "bn", "cs", "de", "el", "en", "eo",
            "es", "et", "fi", "fr", "he", "hi", "hr", "hu", "id", "it",
            "kk", "ko", "lt", "ml", "my", "nb", "nl", "pl", "pt-BR", "pt",
            "ro", "ru", "sk", "sl", "sr-Latn", "sr", "sv", "ta", "te", "tr",
            "uk", "uz", "yue", "zh-Hans", "zh-Hant"
        ]
        return codes.map { code in
            let locale = Locale(identifier: code)
            // Show the language name in its own script (e.g., "Deutsch" for German)
            let nativeName = locale.localizedString(forIdentifier: code) ?? code
            return (code: code, name: nativeName)
        }.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }()

    public init(
        displaySettings: Binding<TextDisplaySettings>,
        nightMode: Binding<Bool>,
        onSettingsChanged: (() -> Void)? = nil
    ) {
        self._displaySettings = displaySettings
        self._nightMode = nightMode
        self.onSettingsChanged = onSettingsChanged
    }

    public var body: some View {
        Form {
            if hasDictionaryPreferences {
                Section(String(localized: "settings_dictionaries")) {
                    if !strongsGreekDictionaries.isEmpty {
                        NavigationLink {
                            DictionaryMultiSelectView(
                                title: String(
                                    localized: "choose_strongs_greek_dictionary_title",
                                    defaultValue: "Strongs Greek dictionary"
                                ),
                                dictionaries: strongsGreekDictionaries,
                                selectedNames: $selectedStrongsGreekDictionaryNames
                            )
                        } label: {
                            settingsSelectionRow(
                                title: String(
                                    localized: "choose_strongs_greek_dictionary_title",
                                    defaultValue: "Strongs Greek dictionary"
                                ),
                                summary: String(
                                    localized: "choose_strongs_greek_dictionary_summary",
                                    defaultValue: "Choose Strongs dictionary for Greek word definitions"
                                ),
                                detail: selectionSummary(
                                    selectedNames: selectedStrongsGreekDictionaryNames,
                                    available: strongsGreekDictionaries
                                )
                            )
                        }
                    }

                    if !strongsHebrewDictionaries.isEmpty {
                        NavigationLink {
                            DictionaryMultiSelectView(
                                title: String(
                                    localized: "choose_strongs_hebrew_dictionary_title",
                                    defaultValue: "Strongs Hebrew dictionary"
                                ),
                                dictionaries: strongsHebrewDictionaries,
                                selectedNames: $selectedStrongsHebrewDictionaryNames
                            )
                        } label: {
                            settingsSelectionRow(
                                title: String(
                                    localized: "choose_strongs_hebrew_dictionary_title",
                                    defaultValue: "Strongs Hebrew dictionary"
                                ),
                                summary: String(
                                    localized: "choose_strongs_hebrew_dictionary_summary",
                                    defaultValue: "Choose Strongs dictionary for Hebrew word definitions"
                                ),
                                detail: selectionSummary(
                                    selectedNames: selectedStrongsHebrewDictionaryNames,
                                    available: strongsHebrewDictionaries
                                )
                            )
                        }
                    }

                    if !robinsonMorphologyDictionaries.isEmpty {
                        NavigationLink {
                            DictionaryMultiSelectView(
                                title: String(
                                    localized: "choose_strongs_greek_morphology_title",
                                    defaultValue: "Robinson Greek morphology"
                                ),
                                dictionaries: robinsonMorphologyDictionaries,
                                selectedNames: $selectedRobinsonMorphologyDictionaryNames
                            )
                        } label: {
                            settingsSelectionRow(
                                title: String(
                                    localized: "choose_strongs_greek_morphology_title",
                                    defaultValue: "Robinson Greek morphology"
                                ),
                                summary: String(
                                    localized: "choose_strongs_greek_morphology_summary",
                                    defaultValue: "Choose dictionary for Robinson Greek morphology definitions"
                                ),
                                detail: selectionSummary(
                                    selectedNames: selectedRobinsonMorphologyDictionaryNames,
                                    available: robinsonMorphologyDictionaries
                                )
                            )
                        }
                    }

                    if !wordLookupDictionaries.isEmpty {
                        NavigationLink {
                            DictionaryInverseMultiSelectView(
                                title: String(
                                    localized: "choose_word_lookup_dictionary_title",
                                    defaultValue: "Word lookup dictionaries"
                                ),
                                dictionaries: wordLookupDictionaries,
                                disabledNames: $disabledWordLookupDictionaryNames
                            )
                        } label: {
                            settingsSelectionRow(
                                title: String(
                                    localized: "choose_word_lookup_dictionary_title",
                                    defaultValue: "Word lookup dictionaries"
                                ),
                                summary: String(
                                    localized: "choose_word_lookup_dictionary_summary",
                                    defaultValue: "Choose dictionaries for looking up words"
                                ),
                                detail: inverseSelectionSummary(
                                    disabledNames: disabledWordLookupDictionaryNames,
                                    available: wordLookupDictionaries
                                )
                            )
                        }
                    }
                }
            }

            Section(String(localized: "prefs_behavior_customization_cat", defaultValue: "Application behavior")) {
                Toggle(
                    String(
                        localized: "prefs_navigate_to_verse_title",
                        defaultValue: "Navigate to verse"
                    ),
                    isOn: Binding(
                        get: { navigateToVerse },
                        set: { newValue in
                            navigateToVerse = newValue
                            let store = SettingsStore(modelContext: modelContext)
                            store.setBool(.navigateToVersePref, value: newValue)
                        }
                    )
                )
                Text(String(
                    localized: "prefs_navigate_to_verse_summary",
                    defaultValue: "Choose verse (and chapter) when selecting a passage"
                ))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Toggle(
                    String(localized: "prefs_screen_keep_on_title", defaultValue: "Keep screen on"),
                    isOn: Binding(
                        get: { screenKeepOn },
                        set: { newValue in
                            screenKeepOn = newValue
                            let store = SettingsStore(modelContext: modelContext)
                            store.setBool(.screenKeepOnPref, value: newValue)
                            applyScreenKeepOn(newValue)
                        }
                    )
                )
                Text(String(
                    localized: "prefs_screen_keep_on_summary",
                    defaultValue: "Prevent screen sleeping while using this app"
                ))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Toggle(
                    String(
                        localized: "prefs_double_tap_to_fullscreen_title",
                        defaultValue: "Double-tap to Fullscreen"
                    ),
                    isOn: Binding(
                        get: { doubleTapToFullscreen },
                        set: { newValue in
                            doubleTapToFullscreen = newValue
                            let store = SettingsStore(modelContext: modelContext)
                            store.setBool(.doubleTapToFullscreen, value: newValue)
                        }
                    )
                )
                Text(String(
                    localized: "prefs_double_tap_to_fullscreen_summary",
                    defaultValue: "Enter fullscreen mode by double-tapping window"
                ))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Toggle(
                    String(localized: "auto_fullscreen", defaultValue: "Fullscreen by scrolling"),
                    isOn: Binding(
                        get: { autoFullscreen },
                        set: { newValue in
                            autoFullscreen = newValue
                            let store = SettingsStore(modelContext: modelContext)
                            store.setBool(.autoFullscreenPref, value: newValue)
                        }
                    )
                )
                Text(String(
                    localized: "auto_fullscreen_summary",
                    defaultValue: "Switch automatically to fullscreen when scrolling text. Tip: you can always also switch to full screen by doubletapping screen."
                ))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Toggle(String(localized: "verse_selection"), isOn: Binding(
                    get: { displaySettings.enableVerseSelection ?? true },
                    set: {
                        displaySettings.enableVerseSelection = $0
                        onSettingsChanged?()
                    }
                ))
                Toggle(
                    String(
                        localized: "prefs_open_links_in_special_window_title",
                        defaultValue: "Links window"
                    ),
                    isOn: Binding(
                        get: { openLinksInSpecialWindow },
                        set: { newValue in
                            openLinksInSpecialWindow = newValue
                            let store = SettingsStore(modelContext: modelContext)
                            store.setBool(.openLinksInSpecialWindowPref, value: newValue)
                        }
                    )
                )
                Text(String(
                    localized: "prefs_open_links_in_special_window_summary",
                    defaultValue: "Open links in special window, for quicker display of cross-references and Strongs"
                ))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section(String(localized: "prefs_display_customization_cat", defaultValue: "Look & feel")) {
                NavigationLink(String(localized: "settings_text_display")) {
                    TextDisplaySettingsView(settings: $displaySettings, onChange: onSettingsChanged)
                }
                NavigationLink(String(localized: "settings_colors")) {
                    ColorSettingsView(settings: $displaySettings, onChange: onSettingsChanged)
                }
                Toggle(String(localized: "night_mode"), isOn: Binding(
                    get: { nightMode },
                    set: {
                        nightMode = $0
                        let store = SettingsStore(modelContext: modelContext)
                        store.setBool("night_mode", value: $0)
                        onSettingsChanged?()
                    }
                ))
                Toggle(
                    String(localized: "prefs_e_ink_mode_title", defaultValue: "Black & white mode"),
                    isOn: Binding(
                        get: { monochromeMode },
                        set: { newValue in
                            monochromeMode = newValue
                            let store = SettingsStore(modelContext: modelContext)
                            store.setBool(.monochromeMode, value: newValue)
                            onSettingsChanged?()
                        }
                    )
                )
                Text(String(
                    localized: "prefs_eink_mode_summary",
                    defaultValue: "Use application in monochrome mode (no colors), making it more suitable for E-ink devices."
                ))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Toggle(
                    String(localized: "prefs_disable_animations_title", defaultValue: "Disable animations"),
                    isOn: Binding(
                        get: { disableAnimations },
                        set: { newValue in
                            disableAnimations = newValue
                            let store = SettingsStore(modelContext: modelContext)
                            store.setBool(.disableAnimations, value: newValue)
                            onSettingsChanged?()
                        }
                    )
                )
                Text(String(
                    localized: "prefs_disable_animations_summary",
                    defaultValue: "Disable various animations such as smooth scrolling."
                ))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Toggle(
                    String(
                        localized: "prefs_disable_click_to_edit_title",
                        defaultValue: "Disable Study Pad click-to-edit"
                    ),
                    isOn: Binding(
                        get: { disableClickToEdit },
                        set: { newValue in
                            disableClickToEdit = newValue
                            let store = SettingsStore(modelContext: modelContext)
                            store.setBool(.disableClickToEdit, value: newValue)
                            onSettingsChanged?()
                        }
                    )
                )
                Text(String(
                    localized: "prefs_disable_click_to_edit_summary",
                    defaultValue: "Requires using the edit button to edit notes in the Study Pad."
                ))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Stepper(
                    value: Binding(
                        get: { fontSizeMultiplier },
                        set: { newValue in
                            fontSizeMultiplier = min(max(newValue, 10), 500)
                            let store = SettingsStore(modelContext: modelContext)
                            store.setInt(.fontSizeMultiplier, value: fontSizeMultiplier)
                            onSettingsChanged?()
                        }
                    ),
                    in: 10...500,
                    step: 10
                ) {
                    HStack {
                        Text(String(
                            localized: "pref_font_size_multiplier_title",
                            defaultValue: "Font size multiplier"
                        ))
                        Spacer()
                        Text("\(fontSizeMultiplier)%")
                            .foregroundStyle(.secondary)
                    }
                }
                Toggle(
                    String(
                        localized: "active_window_indicator_title",
                        defaultValue: "Show active window indicator"
                    ),
                    isOn: Binding(
                        get: { showActiveWindowIndicator },
                        set: { newValue in
                            showActiveWindowIndicator = newValue
                            let store = SettingsStore(modelContext: modelContext)
                            store.setBool(.showActiveWindowIndicator, value: newValue)
                            onSettingsChanged?()
                        }
                    )
                )
                Text(String(
                    localized: "active_window_indicator_summary",
                    defaultValue: "Highlight window corners to help recognising which window is active"
                ))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Picker(String(localized: "settings_language"), selection: $selectedLanguage) {
                    Text(String(localized: "language_system_default")).tag("")
                    ForEach(Self.availableLanguages, id: \.code) { lang in
                        Text(lang.name).tag(lang.code)
                    }
                }
                .onChange(of: selectedLanguage) { _, newValue in
                    if newValue.isEmpty {
                        UserDefaults.standard.removeObject(forKey: "AppleLanguages")
                    } else {
                        UserDefaults.standard.set([newValue], forKey: "AppleLanguages")
                    }
                    UserDefaults.standard.synchronize()
                    showRestartAlert = true
                }
                Text(String(localized: "language_restart_required"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section(String(localized: "settings_security")) {
                Button {
                    showDiscreteHelp = true
                } label: {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                        VStack(alignment: .leading) {
                            Text(String(localized: "discrete_help_title"))
                                .foregroundStyle(.primary)
                            Text(String(localized: "discrete_help_summary"))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Toggle(String(localized: "discrete_mode"), isOn: $discreteMode)
                Text(String(localized: "discrete_mode_description"))
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Toggle(String(localized: "show_calculator"), isOn: $showCalculator)
                Text(String(localized: "show_calculator_description"))
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack {
                    Text(String(localized: "calculator_pin"))
                    Spacer()
                    TextField(String(localized: "calculator_pin_placeholder"), text: $calculatorPin)
                        #if os(iOS)
                        .keyboardType(.numberPad)
                        #endif
                        .multilineTextAlignment(.trailing)
                        .frame(width: 100)
                        .onChange(of: calculatorPin) { _, newValue in
                            let filtered = newValue.filter { $0.isNumber }
                            if filtered != newValue { calculatorPin = filtered }
                        }
                }
                Text(String(localized: "calculator_pin_description"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section(String(localized: "prefs_advanced_settings_cat", defaultValue: "Advanced settings")) {
                Toggle(
                    String(
                        localized: "prefs_show_error_box_title",
                        defaultValue: "Show Javascript error box"
                    ),
                    isOn: Binding(
                        get: { showErrorBox },
                        set: { newValue in
                            showErrorBox = newValue
                            let store = SettingsStore(modelContext: modelContext)
                            store.setBool(.showErrorBox, value: newValue)
                            onSettingsChanged?()
                        }
                    )
                )
                Text(String(
                    localized: "prefs_show_error_box_summary",
                    defaultValue: "Useful for developers when debugging BibleView javascript side errors. This will make the app slower."
                ))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section(String(localized: "settings_data")) {
                NavigationLink(String(localized: "downloads")) {
                    ModuleBrowserView()
                }
                NavigationLink(String(localized: "repositories")) {
                    RepositoryManagerView()
                }
                NavigationLink(String(localized: "import_export")) {
                    ImportExportView()
                }
                NavigationLink(String(localized: "icloud_sync")) {
                    SyncSettingsView()
                }
                NavigationLink(String(localized: "labels")) {
                    LabelManagerView()
                }
            }

            Section(String(localized: "settings_about")) {
                HStack {
                    Text(String(localized: "version"))
                    Spacer()
                    Text("1.0.0")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(String(localized: "settings"))
        .alert(String(localized: "settings_language"), isPresented: $showRestartAlert) {
            Button(String(localized: "ok")) {}
        } message: {
            Text(String(localized: "language_restart_required"))
        }
        .sheet(isPresented: $showDiscreteHelp) {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(String(localized: "discrete_help_par1"))
                        Text(String(localized: "discrete_help_par2"))
                        Text(String(localized: "discrete_help_par3"))
                        Text(String(localized: "discrete_help_ios_note"))
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
                .navigationTitle(String(localized: "settings_security"))
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(String(localized: "done")) { showDiscreteHelp = false }
                    }
                }
            }
        }
        .onAppear {
            // Load installed dictionary modules
            if let mgr = SwordManager() {
                let all = mgr.installedModules()
                strongsGreekDictionaries = all
                    .filter {
                        ($0.category == .dictionary || $0.category == .glossary) &&
                            $0.features.contains(.greekDef)
                    }
                    .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
                strongsHebrewDictionaries = all
                    .filter {
                        ($0.category == .dictionary || $0.category == .glossary) &&
                            $0.features.contains(.hebrewDef)
                    }
                    .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
                robinsonMorphologyDictionaries = all
                    .filter {
                        ($0.category == .dictionary || $0.category == .glossary) &&
                            $0.features.contains(.greekParse)
                    }
                    .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
                wordLookupDictionaries = all
                    .filter {
                        $0.category == .dictionary &&
                            !$0.features.contains(.greekDef) &&
                            !$0.features.contains(.hebrewDef) &&
                            !$0.features.contains(.greekParse)
                    }
                    .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            }
            // Load persisted preferences
            let store = SettingsStore(modelContext: modelContext)
            selectedStrongsGreekDictionaryNames = Set(store.getStringSet(.strongsGreekDictionary))
            selectedStrongsHebrewDictionaryNames = Set(store.getStringSet(.strongsHebrewDictionary))
            selectedRobinsonMorphologyDictionaryNames = Set(store.getStringSet(.robinsonGreekMorphology))
            disabledWordLookupDictionaryNames = Set(store.getStringSet(.disabledWordLookupDictionaries))
            sanitizeDictionaryPreferences(store: store)
            openLinksInSpecialWindow = store.getBool(.openLinksInSpecialWindowPref)
            monochromeMode = store.getBool(.monochromeMode)
            disableAnimations = store.getBool(.disableAnimations)
            disableClickToEdit = store.getBool(.disableClickToEdit)
            showActiveWindowIndicator = store.getBool(.showActiveWindowIndicator)
            showErrorBox = store.getBool(.showErrorBox)
            fontSizeMultiplier = store.getInt(.fontSizeMultiplier)
            navigateToVerse = store.getBool(.navigateToVersePref)
            screenKeepOn = store.getBool(.screenKeepOnPref)
            doubleTapToFullscreen = store.getBool(.doubleTapToFullscreen)
            autoFullscreen = store.getBool(.autoFullscreenPref)
            applyScreenKeepOn(screenKeepOn)
            // Load current language override
            if let overrideLangs = UserDefaults.standard.array(forKey: "AppleLanguages") as? [String],
               let first = overrideLangs.first,
               Self.availableLanguages.contains(where: { $0.code == first }) {
                selectedLanguage = first
            } else {
                selectedLanguage = ""
            }
        }
        .onChange(of: selectedStrongsGreekDictionaryNames) { _, newValue in
            let store = SettingsStore(modelContext: modelContext)
            store.setStringSet(.strongsGreekDictionary, values: Array(newValue))
        }
        .onChange(of: selectedStrongsHebrewDictionaryNames) { _, newValue in
            let store = SettingsStore(modelContext: modelContext)
            store.setStringSet(.strongsHebrewDictionary, values: Array(newValue))
        }
        .onChange(of: selectedRobinsonMorphologyDictionaryNames) { _, newValue in
            let store = SettingsStore(modelContext: modelContext)
            store.setStringSet(.robinsonGreekMorphology, values: Array(newValue))
        }
        .onChange(of: disabledWordLookupDictionaryNames) { _, newValue in
            let store = SettingsStore(modelContext: modelContext)
            store.setStringSet(.disabledWordLookupDictionaries, values: Array(newValue))
        }
    }

    private var hasDictionaryPreferences: Bool {
        !strongsGreekDictionaries.isEmpty ||
            !strongsHebrewDictionaries.isEmpty ||
            !robinsonMorphologyDictionaries.isEmpty ||
            !wordLookupDictionaries.isEmpty
    }

    @ViewBuilder
    private func settingsSelectionRow(title: String, summary: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .foregroundStyle(.primary)
            Text(summary)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(detail)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
    }

    private func selectionSummary(selectedNames: Set<String>, available: [ModuleInfo]) -> String {
        guard !available.isEmpty else {
            return String(localized: "none", defaultValue: "None")
        }
        let availableNames = Set(available.map(\.name))
        let effectiveSelected = selectedNames.isEmpty ? availableNames : selectedNames.intersection(availableNames)
        if effectiveSelected.count >= availableNames.count {
            return String(localized: "all", defaultValue: "All")
        }
        return String(localized: "settings_selected_count", defaultValue: "\(effectiveSelected.count) selected")
    }

    private func inverseSelectionSummary(disabledNames: Set<String>, available: [ModuleInfo]) -> String {
        guard !available.isEmpty else {
            return String(localized: "none", defaultValue: "None")
        }
        let availableNames = Set(available.map(\.name))
        let enabledCount = availableNames.subtracting(disabledNames).count
        if enabledCount >= availableNames.count {
            return String(localized: "all", defaultValue: "All")
        }
        return String(localized: "settings_selected_count", defaultValue: "\(enabledCount) selected")
    }

    private func applyScreenKeepOn(_ enabled: Bool) {
        #if os(iOS)
        UIApplication.shared.isIdleTimerDisabled = enabled
        #endif
    }

    /// Remove persisted dictionary selections that are no longer valid for current module lists.
    /// Keeps Android semantics where empty selected-set means "all enabled".
    private func sanitizeDictionaryPreferences(store: SettingsStore) {
        let validGreek = Set(strongsGreekDictionaries.map(\.name))
        if !selectedStrongsGreekDictionaryNames.isEmpty {
            let sanitized = selectedStrongsGreekDictionaryNames.intersection(validGreek)
            if sanitized != selectedStrongsGreekDictionaryNames {
                selectedStrongsGreekDictionaryNames = sanitized
                store.setStringSet(.strongsGreekDictionary, values: Array(sanitized))
            }
        }

        let validHebrew = Set(strongsHebrewDictionaries.map(\.name))
        if !selectedStrongsHebrewDictionaryNames.isEmpty {
            let sanitized = selectedStrongsHebrewDictionaryNames.intersection(validHebrew)
            if sanitized != selectedStrongsHebrewDictionaryNames {
                selectedStrongsHebrewDictionaryNames = sanitized
                store.setStringSet(.strongsHebrewDictionary, values: Array(sanitized))
            }
        }

        let validMorph = Set(robinsonMorphologyDictionaries.map(\.name))
        if !selectedRobinsonMorphologyDictionaryNames.isEmpty {
            let sanitized = selectedRobinsonMorphologyDictionaryNames.intersection(validMorph)
            if sanitized != selectedRobinsonMorphologyDictionaryNames {
                selectedRobinsonMorphologyDictionaryNames = sanitized
                store.setStringSet(.robinsonGreekMorphology, values: Array(sanitized))
            }
        }

        let validWordLookup = Set(wordLookupDictionaries.map(\.name))
        let sanitizedDisabled = disabledWordLookupDictionaryNames.intersection(validWordLookup)
        if sanitizedDisabled != disabledWordLookupDictionaryNames {
            disabledWordLookupDictionaryNames = sanitizedDisabled
            store.setStringSet(.disabledWordLookupDictionaries, values: Array(sanitizedDisabled))
        }
    }
}

private struct DictionaryMultiSelectView: View {
    let title: String
    let dictionaries: [ModuleInfo]
    @Binding var selectedNames: Set<String>

    var body: some View {
        List(dictionaries, id: \.name) { dictionary in
            Toggle(
                isOn: Binding(
                    get: {
                        selectedNames.isEmpty || selectedNames.contains(dictionary.name)
                    },
                    set: { isEnabled in
                        updateSelection(dictionaryName: dictionary.name, isEnabled: isEnabled)
                    }
                )
            ) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(dictionary.name)
                    Text(dictionary.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(title)
    }

    private func updateSelection(dictionaryName: String, isEnabled: Bool) {
        let allNames = Set(dictionaries.map(\.name))
        var effectiveSelected = selectedNames.isEmpty ? allNames : selectedNames

        if isEnabled {
            effectiveSelected.insert(dictionaryName)
        } else {
            effectiveSelected.remove(dictionaryName)
        }

        if effectiveSelected == allNames {
            selectedNames = []
        } else {
            selectedNames = effectiveSelected
        }
    }
}

private struct DictionaryInverseMultiSelectView: View {
    let title: String
    let dictionaries: [ModuleInfo]
    @Binding var disabledNames: Set<String>

    var body: some View {
        List(dictionaries, id: \.name) { dictionary in
            Toggle(
                isOn: Binding(
                    get: { !disabledNames.contains(dictionary.name) },
                    set: { isEnabled in
                        if isEnabled {
                            disabledNames.remove(dictionary.name)
                        } else {
                            disabledNames.insert(dictionary.name)
                        }
                    }
                )
            ) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(dictionary.name)
                    Text(dictionary.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(title)
    }
}
