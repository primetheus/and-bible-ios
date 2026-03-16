# Android Settings Contract (Source Of Truth)

This file captures the explicit Android contract to match on iOS.

Primary sources:
- Settings schema: `and-bible/app/src/main/res/xml/settings.xml:25-253`
- Labels/summaries: `and-bible/app/src/main/res/values/strings.xml`
- Option arrays: `and-bible/app/src/main/res/values/arrays.xml`
- Runtime rules/visibility: `and-bible/app/src/main/java/net/bible/android/view/activity/settings/SettingsActivity.kt:219-357`
- Runtime behavior consumers: callsites listed below per key.

## Category Titles

| Category | String key | English text | Reference |
|---|---|---|---|
| Dictionaries | `prefs_dictionaries_cat` | Dictionaries | `strings.xml:234` |
| Application behavior | `prefs_behavior_customization_cat` | Application behavior | `strings.xml:195` |
| Look & feel | `prefs_display_customization_cat` | Look & feel | `strings.xml:194` |
| Settings for the persecuted | `prefs_persecution_cat` | Settings for the persecuted | `strings.xml:1147` |
| Advanced settings | `prefs_advanced_settings_cat` | Advanced settings | `strings.xml:193` |

## Per-Key Contract

| Key | Type | Default (from XML/runtime) | Label / Summary (en) | Runtime behavior reference |
|---|---|---|---|---|
| `strongs_greek_dictionary` | `MultiSelectListPreference` | Runtime default = all available entries (`SettingsActivity.kt:183-196`) | `choose_strongs_greek_dictionary_title` / `choose_strongs_greek_dictionary_summary` (`strings.xml:235-236`) | `SwordDocumentFacade.kt:94` |
| `strongs_hebrew_dictionary` | `MultiSelectListPreference` | Runtime default = all available entries (`SettingsActivity.kt:183-196`) | `choose_strongs_hebrew_dictionary_title` / `choose_strongs_hebrew_dictionary_summary` (`strings.xml:237-238`) | `SwordDocumentFacade.kt:96` |
| `robinson_greek_morphology` | `MultiSelectListPreference` | Runtime default = all available entries (`SettingsActivity.kt:183-196`) | `choose_strongs_greek_morphology_title` / `choose_strongs_greek_morphology_summary` (`strings.xml:239-240`) | `SwordDocumentFacade.kt:92` |
| `disabled_word_lookup_dictionaries` | `InverseMultiSelectListPreference` | No XML default; inverse logic means empty disabled set | `choose_word_lookup_dictionary_title` / `choose_word_lookup_dictionary_summary` (`strings.xml:241-242`) | `SwordDocumentFacade.kt:100` |
| `navigate_to_verse_pref` | `SwitchPreferenceCompat` | `false` (`settings.xml:55`) | `prefs_navigate_to_verse_title` / `prefs_navigate_to_verse_summary` (`strings.xml:164-165`) | `GridChoosePassageBook.kt:134`, `GridChoosePassageChapter.kt:81` |
| `open_links_in_special_window_pref` | `SwitchPreferenceCompat` | `true` (`settings.xml:62`) | `prefs_open_links_in_special_window_title` / `prefs_open_links_in_special_window_summary` (`strings.xml:166-167`) | `LinkControl.kt:401-402`, `BibleView.kt:1261` |
| `screen_keep_on_pref` | `SwitchPreferenceCompat` | `false` (`settings.xml:67`) | `prefs_screen_keep_on_title` / `prefs_screen_keep_on_summary` (`strings.xml:169-170`) | `ActivityBase.kt:453` |
| `double_tap_to_fullscreen` | `SwitchPreferenceCompat` | `true` (`settings.xml:73`) | `prefs_double_tap_to_fullscreen_title` / `prefs_double_tap_to_fullscreen_summary` (`strings.xml:1062-1063`) | `BibleGestureListener.kt:156` |
| `auto_fullscreen_pref` | `SwitchPreferenceCompat` | `false` (`settings.xml:79`) | `auto_fullscreen` / `auto_fullscreen_summary` (`strings.xml:183`, `190`) | `BibleGestureListener.kt:43` |
| `toolbar_button_actions` | `ListPreference` | Runtime fallback to `default` when blank (`SettingsActivity.kt:262-265`) | `prefs_toolbar_button_action_title` / `prefs_toolbar_button_action_summary` (`strings.xml:151-152`) | `MainBibleActivity.kt:1055` |
| `disable_two_step_bookmarking` | `SwitchPreferenceCompat` | `false` (`settings.xml:91`) | `prefs_disable_two_step_bookmarking_title` / `prefs_disable_two_step_bookmarking_summary` (`strings.xml:1060-1061`) | `BibleView.kt:566` |
| `bible_view_swipe_mode` | `ListPreference` | `CHAPTER` (`settings.xml:100`) | `prefs_bible_view_swipe_mode_title` / `prefs_bible_view_swipe_mode_summary` (`strings.xml:1311-1312`) | `CommonUtils.kt:440` |
| `volume_keys_scroll` | `SwitchPreferenceCompat` | `true` (`settings.xml:104`) | `prefs_volume_keys_scroll_title` / `prefs_volume_keys_scroll_summary` (`strings.xml:1316-1317`) | `MainBibleActivity.kt:1856` |
| `night_mode_pref3` | `ListPreference` | XML default `manual` (`settings.xml:113`), runtime entry-set/default adjusted (`SettingsActivity.kt:225-234`) | `prefs_night_mode_title` / `prefs_night_mode_summary` (`strings.xml:157-158`) | `ScreenSettings.kt:62-64` |
| `locale_pref` | `ListPreference` | `""` (`settings.xml:124`) | `prefs_interface_locale_title` / `prefs_interface_locale_summary` (`strings.xml:171-172`) | `CommonUtils.kt:457`, `LocaleHelper.kt:31` |
| `monochrome_mode` | `SwitchPreferenceCompat` | `false` (`settings.xml:128`) | `prefs_e_ink_mode_title` / `prefs_eink_mode_summary` (`strings.xml:106-107`) | `CommonUtils.kt:435` |
| `disable_animations` | `SwitchPreferenceCompat` | `false` (`settings.xml:134`) | `prefs_disable_animations_title` / `prefs_disable_animations_summary` (`strings.xml:109-110`) | `CommonUtils.kt:436` |
| `disable_click_to_edit` | `SwitchPreferenceCompat` | `false` (`settings.xml:141`) | `prefs_disable_click_to_edit_title` / `prefs_disable_click_to_edit_summary` (`strings.xml:112-113`) | consumed via JS appSettings payload (Android bridge path) |
| `font_size_multiplier` | `SeekBarPreference` | `100` (`settings.xml:147`), min `10`, max `500` (`settings.xml:148-149`) | `pref_font_size_multiplier_title` (`strings.xml:1307`) | `CommonUtils.kt:438-439` |
| `full_screen_hide_buttons_pref` | `SwitchPreferenceCompat` | `true` (`settings.xml:156`) | `full_screen_hide_buttons_pref_title` / `full_screen_hide_buttons_pref_summary` (`strings.xml:231-232`) | `SplitBibleArea.kt:319` |
| `hide_window_buttons` | `SwitchPreferenceCompat` | `false` (`settings.xml:162`) | `hide_window_buttons_title` / `hide_window_buttons_summary` (`strings.xml:226-227`) | `SplitBibleArea.kt:316` |
| `hide_bible_reference_overlay` | `SwitchPreferenceCompat` | `false` (`settings.xml:168`) | `hide_bible_reference_overlay_title` / `hide_bible_reference_overlay_summary` (`strings.xml:228-229`) | `SplitBibleArea.kt:624` |
| `show_active_window_indicator` | `SwitchPreferenceCompat` | `true` (`settings.xml:174`) | `active_window_indicator_title` / `active_window_indicator_summary` (`strings.xml:952-953`) | `BibleView.kt:1379` |
| `disable_bible_bookmark_modal_buttons` | `InverseMultiSelectListPreference` | No XML default | `prefs_in_window_bible_bookmark_modal_buttons_title` / `prefs_in_window_bookmark_modal_buttons_description` (`strings.xml:1284`, `1286`) | `BibleView.kt:1397` |
| `disable_gen_bookmark_modal_buttons` | `InverseMultiSelectListPreference` | No XML default | `prefs_in_window_gen_bookmark_modal_buttons_title` / `prefs_in_window_bookmark_modal_buttons_description` (`strings.xml:1285`, `1286`) | `BibleView.kt:1400` |
| `discrete_help` | `Preference` | N/A | `prefs_persecuted_help` / `prefs_persecuted_summary` (`strings.xml:1157`, `1159`) | click behavior dialog `SettingsActivity.kt:291-319` |
| `discrete_mode` | `SwitchPreferenceCompat` | `false` (`settings.xml:202`) | `prefs_discrete_mode` / `prefs_discrete_mode_desc` (`strings.xml:1148-1149`) | icon/name switch `CommonUtils.kt:1529-1563`, `MainBibleActivity.kt:1937` |
| `show_calculator` | `SwitchPreferenceCompat` | `false` (`settings.xml:207`) | `prefs_show_calculator` (title), summary set dynamically from `calculator_par*` (`SettingsActivity.kt:285-289`) | startup calculator gate `CommonUtils.kt:1583`, `StartupActivity.kt:386-401` |
| `calculator_pin` | `EditTextPreference` | `1234` (`settings.xml:213`) | `prefs_calculator_pin` / `prefs_calculator_pin_desc` (`strings.xml:1151-1152`) | calculator unlock `CalculatorActivity.kt:263-270` |
| `experimental_features` | `MultiSelectListPreference` | `@null` (`settings.xml:223`) | `prefs_experimental_features_title` / `prefs_experimental_features_summary` (`strings.xml:946-947`) | `CommonUtils.kt:443` |
| `enable_bluetooth_pref` | `SwitchPreferenceCompat` | `true` (`settings.xml:230`) | `prefs_enable_bluetooth_title` / `prefs_enable_bluetooth_summary` (`strings.xml:256-257`) | `MediaButtonHandler.kt:56`, `89`, `132` |
| `request_sdcard_permission_pref` | `SwitchPreferenceCompat` | `false` (`settings.xml:234`) | `prefs_request_sdcard_permission_title` / `prefs_request_sdcard_permission_summary` (`strings.xml:175-176`) | `MainBibleActivity.kt:2077`, `DocumentControl.kt:167` |
| `show_errorbox` | `SwitchPreferenceCompat` | `false` (`settings.xml:238`) | `prefs_show_error_box_title` / `prefs_show_error_box_summary` (`strings.xml:950-951`) | `BibleView.kt:1387` |
| `open_links` | `Preference` | `false` (`settings.xml:244`) | `open_bible_links_title` / `open_bible_links_summary` (`strings.xml:1209-1210`) | click opens OS App-links settings `SettingsActivity.kt:334-349` |
| `crash_app` | `Preference` | N/A | `crash_app` / `crash_app_summary` (`strings.xml`, same file) | click behavior only in beta `SettingsActivity.kt:321-333` |

## Android Runtime Visibility / Dynamic Rules

| Rule | Reference |
|---|---|
| `night_mode_pref3` entries and defaults are adjusted by `autoModeAvailable` | `SettingsActivity.kt:225-234` |
| `show_errorbox` visible only in beta builds | `SettingsActivity.kt:235-236` |
| dictionaries category hidden if no dictionary modules available | `SettingsActivity.kt:237-247` |
| `font_size_multiplier` summary shows current multiplier string | `SettingsActivity.kt:249-260` |
| `request_sdcard_permission_pref` hidden on Android Q+ | `SettingsActivity.kt:267-270` |
| `calculator_pin` editor forced numeric input | `SettingsActivity.kt:272-274` |
| `discrete_mode` and `show_calculator` hidden in discrete flavor | `SettingsActivity.kt:276-284` |
| `show_calculator` summary built from calculator paragraphs | `SettingsActivity.kt:285-289` |
| `discrete_help` dialog content differs by build flavor | `SettingsActivity.kt:291-307` |
| `crash_app` visible only in beta | `SettingsActivity.kt:321-333` |
| `open_links` visible only on API >= S; otherwise hidden | `SettingsActivity.kt:334-349` |

## List / Multi-Select Option Contracts

| Key | Options contract | Reference |
|---|---|---|
| `toolbar_button_actions` | `default`, `swap-menu`, `swap-activity` with mapped descriptions | `arrays.xml:44-53` |
| `bible_view_swipe_mode` | `CHAPTER`, `PAGE`, `NONE` | `arrays.xml:56-66` |
| `night_mode_pref3` | runtime-dependent set from `system/automatic/manual` or `system/manual` | `arrays.xml:69-95`, `SettingsActivity.kt:225-234` |
| `locale_pref` | description/value arrays in strict positional order | `arrays.xml:100-189` |
| `disable_bible_bookmark_modal_buttons` | action names/ids arrays | `arrays.xml:190-209` |
| `disable_gen_bookmark_modal_buttons` | action names/ids arrays | `arrays.xml:210-221` |
| `experimental_features` | names/ids arrays | `arrays.xml:224-231` |

## Ownership And Review Checklist

- Owner: iOS parity maintainers (`and-bible-ios`)
- Source owner: Android settings maintainers (`and-bible`)
- Review cadence: verify on each Android settings schema/string/array change

Checklist for parity updates:

- Confirm `settings.xml` key set still matches this contract.
- Confirm defaults in XML/runtime code still match this contract.
- Confirm labels/summaries and option arrays still match this contract.
- Confirm runtime visibility/dynamic rules still match this contract.
- Update iOS backlog tickets when Android contract changes.
