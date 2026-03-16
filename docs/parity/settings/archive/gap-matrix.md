# SETPAR-601 Remaining Localization Gap Matrix

- Generated: 2026-03-10
- Scope: parity-sensitive settings keys (58 keys) across non-English iOS locales (44 locales).
- Data sources:
  - iOS locale files: `AndBible/*.lproj/Localizable.strings` and `Localizations/*.lproj/Localizable.strings`
  - Android locale files: `and-bible/app/src/main/res/values*/strings.xml` + `values/untranslated_strings.xml`

Status legend:
- `localized`: iOS value is non-English (different from iOS English baseline).
- `source_gap`: iOS value is English and Android locale has no value for that key.
- `android_english`: iOS value is English and Android locale value exists but is also English.
- `ios_gap`: iOS value is English while Android locale has a non-English translation.

## Headline

- `ios_gap` count: **0**
- `source_gap` count: **742**
- `android_english` count: **3**

## Locale-by-Locale Matrix

| Locale | localized | source_gap | android_english | ios_gap |
|---|---:|---:|---:|---:|
| `af` | 45 | 13 | 0 | 0 |
| `ar` | 38 | 20 | 0 | 0 |
| `az` | 7 | 51 | 0 | 0 |
| `bg` | 6 | 52 | 0 | 0 |
| `bn` | 45 | 13 | 0 | 0 |
| `cs` | 50 | 8 | 0 | 0 |
| `de` | 49 | 8 | 1 | 0 |
| `el` | 50 | 8 | 0 | 0 |
| `eo` | 50 | 8 | 0 | 0 |
| `es` | 50 | 8 | 0 | 0 |
| `et` | 32 | 26 | 0 | 0 |
| `fi` | 48 | 10 | 0 | 0 |
| `fr` | 49 | 9 | 0 | 0 |
| `he` | 44 | 14 | 0 | 0 |
| `hi` | 41 | 17 | 0 | 0 |
| `hr` | 45 | 13 | 0 | 0 |
| `hu` | 45 | 13 | 0 | 0 |
| `id` | 11 | 47 | 0 | 0 |
| `it` | 50 | 8 | 0 | 0 |
| `kk` | 45 | 13 | 0 | 0 |
| `ko` | 35 | 22 | 1 | 0 |
| `lt` | 50 | 8 | 0 | 0 |
| `ml` | 4 | 54 | 0 | 0 |
| `my` | 41 | 17 | 0 | 0 |
| `nb` | 30 | 28 | 0 | 0 |
| `nl` | 45 | 13 | 0 | 0 |
| `pl` | 50 | 8 | 0 | 0 |
| `pt` | 50 | 8 | 0 | 0 |
| `pt-BR` | 49 | 9 | 0 | 0 |
| `ro` | 50 | 8 | 0 | 0 |
| `ru` | 45 | 13 | 0 | 0 |
| `sk` | 45 | 13 | 0 | 0 |
| `sl` | 50 | 8 | 0 | 0 |
| `sr` | 45 | 13 | 0 | 0 |
| `sr-Latn` | 45 | 13 | 0 | 0 |
| `sv` | 50 | 8 | 0 | 0 |
| `ta` | 44 | 13 | 1 | 0 |
| `te` | 45 | 13 | 0 | 0 |
| `tr` | 47 | 11 | 0 | 0 |
| `uk` | 46 | 12 | 0 | 0 |
| `uz` | 6 | 52 | 0 | 0 |
| `yue` | 45 | 13 | 0 | 0 |
| `zh-Hans` | 45 | 13 | 0 | 0 |
| `zh-Hant` | 45 | 13 | 0 | 0 |

## Key-by-Locale Matrix

| Key | ios_gap locales | source_gap locales | android_english locales |
|---|---|---|---|
| `choose_strongs_greek_dictionary_title` | - | `az`, `bg`, `id`, `ml`, `uz` | - |
| `choose_strongs_greek_dictionary_summary` | - | `az`, `bg`, `et`, `id`, `ml`, `uz` | - |
| `choose_strongs_hebrew_dictionary_title` | - | `az`, `bg`, `id`, `ml`, `uz` | - |
| `choose_strongs_hebrew_dictionary_summary` | - | `az`, `bg`, `et`, `id`, `ml`, `uz` | - |
| `choose_strongs_greek_morphology_title` | - | `az`, `bg`, `id`, `ml`, `uz` | `ko` |
| `choose_strongs_greek_morphology_summary` | - | `az`, `bg`, `et`, `id`, `ml`, `uz` | - |
| `choose_word_lookup_dictionary_title` | - | `af`, `ar`, `az`, `bg`, `bn`, `cs`, `de`, `el`, `eo`, `es`, `et`, `fi`, `fr`, `he`, `hi`, `hr`, `hu`, `id`, `it`, `kk`, `ko`, `lt`, `ml`, `my`, `nb`, `nl`, `pl`, `pt`, `pt-BR`, `ro`, `ru`, `sk`, `sl`, `sr`, `sr-Latn`, `sv`, `ta`, `te`, `tr`, `uk`, `uz`, `yue`, `zh-Hans`, `zh-Hant` | - |
| `choose_word_lookup_dictionary_summary` | - | `af`, `ar`, `az`, `bg`, `bn`, `cs`, `de`, `el`, `eo`, `es`, `et`, `fi`, `fr`, `he`, `hi`, `hr`, `hu`, `id`, `it`, `kk`, `ko`, `lt`, `ml`, `my`, `nb`, `nl`, `pl`, `pt`, `pt-BR`, `ro`, `ru`, `sk`, `sl`, `sr`, `sr-Latn`, `sv`, `ta`, `te`, `tr`, `uk`, `uz`, `yue`, `zh-Hans`, `zh-Hant` | - |
| `prefs_behavior_customization_cat` | - | `az`, `bg`, `id`, `ml`, `uz` | - |
| `prefs_display_customization_cat` | - | `az`, `bg`, `id`, `ml`, `uz` | `de` |
| `prefs_advanced_settings_cat` | - | `az`, `bg`, `id`, `ml`, `uz` | - |
| `prefs_navigate_to_verse_title` | - | - | - |
| `prefs_navigate_to_verse_summary` | - | - | - |
| `prefs_open_links_in_special_window_title` | - | `az`, `bg`, `ml`, `nb`, `uz` | - |
| `prefs_open_links_in_special_window_summary` | - | `az`, `bg`, `et`, `ml`, `nb`, `uz` | - |
| `prefs_screen_keep_on_title` | - | `ml` | - |
| `prefs_screen_keep_on_summary` | - | `ml` | - |
| `prefs_double_tap_to_fullscreen_title` | - | `az`, `bg`, `id`, `ml`, `uz` | - |
| `prefs_double_tap_to_fullscreen_summary` | - | `az`, `bg`, `id`, `ml`, `uz` | - |
| `auto_fullscreen` | - | `bg`, `ml`, `uz` | - |
| `auto_fullscreen_summary` | - | `az`, `bg`, `id`, `ml`, `uz` | - |
| `prefs_toolbar_button_action_title` | - | `az`, `bg`, `et`, `id`, `ml`, `nb`, `uz` | - |
| `prefs_toolbar_button_action_summary` | - | `az`, `bg`, `et`, `id`, `ml`, `uz` | - |
| `prefs_disable_two_step_bookmarking_title` | - | `ar`, `az`, `bg`, `id`, `ko`, `ml`, `nb`, `uz` | - |
| `prefs_disable_two_step_bookmarking_summary` | - | `ar`, `az`, `bg`, `et`, `id`, `ko`, `ml`, `nb`, `uz` | `ta` |
| `prefs_bible_view_swipe_mode_title` | - | `af`, `ar`, `az`, `bg`, `bn`, `et`, `he`, `hi`, `hr`, `hu`, `id`, `kk`, `ko`, `ml`, `my`, `nb`, `nl`, `ru`, `sk`, `sr`, `sr-Latn`, `ta`, `te`, `uk`, `uz`, `yue`, `zh-Hans`, `zh-Hant` | - |
| `prefs_bible_view_swipe_mode_summary` | - | `af`, `ar`, `az`, `bg`, `bn`, `et`, `he`, `hi`, `hr`, `hu`, `id`, `kk`, `ko`, `ml`, `my`, `nb`, `nl`, `ru`, `sk`, `sr`, `sr-Latn`, `ta`, `te`, `uk`, `uz`, `yue`, `zh-Hans`, `zh-Hant` | - |
| `prefs_volume_keys_scroll_title` | - | `af`, `ar`, `az`, `bg`, `bn`, `cs`, `de`, `el`, `eo`, `es`, `et`, `fi`, `fr`, `he`, `hi`, `hr`, `hu`, `id`, `it`, `kk`, `ko`, `lt`, `ml`, `my`, `nb`, `nl`, `pl`, `pt`, `pt-BR`, `ro`, `ru`, `sk`, `sl`, `sr`, `sr-Latn`, `sv`, `ta`, `te`, `tr`, `uk`, `uz`, `yue`, `zh-Hans`, `zh-Hant` | - |
| `prefs_volume_keys_scroll_summary` | - | `af`, `ar`, `az`, `bg`, `bn`, `cs`, `de`, `el`, `eo`, `es`, `et`, `fi`, `fr`, `he`, `hi`, `hr`, `hu`, `id`, `it`, `kk`, `ko`, `lt`, `ml`, `my`, `nb`, `nl`, `pl`, `pt`, `pt-BR`, `ro`, `ru`, `sk`, `sl`, `sr`, `sr-Latn`, `sv`, `ta`, `te`, `tr`, `uk`, `uz`, `yue`, `zh-Hans`, `zh-Hant` | - |
| `prefs_night_mode_title` | - | `az`, `bg`, `ml`, `uz` | - |
| `prefs_night_mode_summary` | - | `az`, `bg`, `ml`, `uz` | - |
| `prefs_interface_locale_title` | - | - | - |
| `prefs_interface_locale_summary` | - | - | - |
| `prefs_e_ink_mode_title` | - | `az`, `bg`, `id`, `ml`, `uz` | - |
| `prefs_eink_mode_summary` | - | `az`, `bg`, `id`, `ml`, `uz` | - |
| `prefs_disable_animations_title` | - | `az`, `bg`, `id`, `ml`, `uz` | - |
| `prefs_disable_animations_summary` | - | `az`, `bg`, `id`, `ml`, `uz` | - |
| `prefs_disable_click_to_edit_title` | - | `af`, `ar`, `az`, `bg`, `bn`, `cs`, `de`, `el`, `eo`, `es`, `et`, `fi`, `fr`, `he`, `hi`, `hr`, `hu`, `id`, `it`, `kk`, `ko`, `lt`, `ml`, `my`, `nb`, `nl`, `pl`, `pt`, `pt-BR`, `ro`, `ru`, `sk`, `sl`, `sr`, `sr-Latn`, `sv`, `ta`, `te`, `tr`, `uk`, `uz`, `yue`, `zh-Hans`, `zh-Hant` | - |
| `prefs_disable_click_to_edit_summary` | - | `af`, `ar`, `az`, `bg`, `bn`, `cs`, `de`, `el`, `eo`, `es`, `et`, `fi`, `fr`, `he`, `hi`, `hr`, `hu`, `id`, `it`, `kk`, `ko`, `lt`, `ml`, `my`, `nb`, `nl`, `pl`, `pt`, `pt-BR`, `ro`, `ru`, `sk`, `sl`, `sr`, `sr-Latn`, `sv`, `ta`, `te`, `tr`, `uk`, `uz`, `yue`, `zh-Hans`, `zh-Hant` | - |
| `pref_font_size_multiplier_title` | - | `af`, `ar`, `az`, `bg`, `bn`, `fr`, `he`, `hi`, `hr`, `hu`, `id`, `kk`, `ko`, `ml`, `my`, `nb`, `nl`, `ru`, `sk`, `sr`, `sr-Latn`, `ta`, `te`, `tr`, `uz`, `yue`, `zh-Hans`, `zh-Hant` | - |
| `full_screen_hide_buttons_pref_title` | - | `az`, `bg`, `id`, `ml`, `uz` | - |
| `full_screen_hide_buttons_pref_summary` | - | `az`, `bg`, `id`, `ml`, `uz` | - |
| `hide_window_buttons_title` | - | `az`, `bg`, `id`, `ml`, `uz` | - |
| `hide_window_buttons_summary` | - | `az`, `bg`, `et`, `id`, `ml`, `nb`, `uz` | - |
| `hide_bible_reference_overlay_title` | - | `az`, `bg`, `et`, `id`, `ml`, `nb`, `uz` | - |
| `hide_bible_reference_overlay_summary` | - | `az`, `bg`, `et`, `id`, `ml`, `nb`, `uz` | - |
| `active_window_indicator_title` | - | `az`, `bg`, `id`, `ko`, `ml`, `nb`, `uz` | - |
| `active_window_indicator_summary` | - | `ar`, `az`, `bg`, `et`, `id`, `ko`, `ml`, `nb`, `uz` | - |
| `prefs_experimental_features_title` | - | `af`, `ar`, `az`, `bg`, `bn`, `et`, `fi`, `he`, `hi`, `hr`, `hu`, `id`, `kk`, `ko`, `ml`, `my`, `nb`, `nl`, `ru`, `sk`, `sr`, `sr-Latn`, `ta`, `te`, `tr`, `uk`, `uz`, `yue`, `zh-Hans`, `zh-Hant` | - |
| `prefs_experimental_features_summary` | - | `af`, `ar`, `az`, `bg`, `bn`, `et`, `fi`, `he`, `hi`, `hr`, `hu`, `id`, `kk`, `ko`, `ml`, `my`, `nb`, `nl`, `pt-BR`, `ru`, `sk`, `sr`, `sr-Latn`, `ta`, `te`, `tr`, `uk`, `uz`, `yue`, `zh-Hans`, `zh-Hant` | - |
| `prefs_enable_bluetooth_title` | - | `az`, `bg`, `hi`, `id`, `ko`, `ml`, `my`, `uz` | - |
| `prefs_enable_bluetooth_summary` | - | `az`, `bg`, `hi`, `id`, `ko`, `ml`, `my`, `nb`, `uz` | - |
| `prefs_show_error_box_title` | - | `ar`, `az`, `bg`, `et`, `id`, `ml`, `nb`, `uz` | - |
| `prefs_show_error_box_summary` | - | `ar`, `az`, `bg`, `et`, `id`, `ko`, `ml`, `nb`, `uz` | - |
| `open_bible_links_title` | - | `ar`, `az`, `bg`, `hi`, `id`, `ko`, `ml`, `my`, `nb`, `uz` | - |
| `open_bible_links_summary` | - | `ar`, `az`, `bg`, `et`, `he`, `hi`, `id`, `ko`, `ml`, `my`, `nb`, `uz` | - |
| `crash_app` | - | `af`, `ar`, `az`, `bg`, `bn`, `cs`, `de`, `el`, `eo`, `es`, `et`, `fi`, `fr`, `he`, `hi`, `hr`, `hu`, `id`, `it`, `kk`, `ko`, `lt`, `ml`, `my`, `nb`, `nl`, `pl`, `pt`, `pt-BR`, `ro`, `ru`, `sk`, `sl`, `sr`, `sr-Latn`, `sv`, `ta`, `te`, `tr`, `uk`, `uz`, `yue`, `zh-Hans`, `zh-Hant` | - |
| `crash_app_summary` | - | `af`, `ar`, `az`, `bg`, `bn`, `cs`, `de`, `el`, `eo`, `es`, `et`, `fi`, `fr`, `he`, `hi`, `hr`, `hu`, `id`, `it`, `kk`, `ko`, `lt`, `ml`, `my`, `nb`, `nl`, `pl`, `pt`, `pt-BR`, `ro`, `ru`, `sk`, `sl`, `sr`, `sr-Latn`, `sv`, `ta`, `te`, `tr`, `uk`, `uz`, `yue`, `zh-Hans`, `zh-Hant` | - |

## Remaining Untranslated Gaps (Source-Limited)

- `af`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `crash_app`, `crash_app_summary`
- `ar`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_disable_two_step_bookmarking_title`, `prefs_disable_two_step_bookmarking_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `active_window_indicator_summary`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `prefs_show_error_box_title`, `prefs_show_error_box_summary`, `open_bible_links_title`, `open_bible_links_summary`, `crash_app`, `crash_app_summary`
- `az`: `choose_strongs_greek_dictionary_title`, `choose_strongs_greek_dictionary_summary`, `choose_strongs_hebrew_dictionary_title`, `choose_strongs_hebrew_dictionary_summary`, `choose_strongs_greek_morphology_title`, `choose_strongs_greek_morphology_summary`, `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_behavior_customization_cat`, `prefs_display_customization_cat`, `prefs_advanced_settings_cat`, `prefs_open_links_in_special_window_title`, `prefs_open_links_in_special_window_summary`, `prefs_double_tap_to_fullscreen_title`, `prefs_double_tap_to_fullscreen_summary`, `auto_fullscreen_summary`, `prefs_toolbar_button_action_title`, `prefs_toolbar_button_action_summary`, `prefs_disable_two_step_bookmarking_title`, `prefs_disable_two_step_bookmarking_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_night_mode_title`, `prefs_night_mode_summary`, `prefs_e_ink_mode_title`, `prefs_eink_mode_summary`, `prefs_disable_animations_title`, `prefs_disable_animations_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `full_screen_hide_buttons_pref_title`, `full_screen_hide_buttons_pref_summary`, `hide_window_buttons_title`, `hide_window_buttons_summary`, `hide_bible_reference_overlay_title`, `hide_bible_reference_overlay_summary`, `active_window_indicator_title`, `active_window_indicator_summary`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `prefs_enable_bluetooth_title`, `prefs_enable_bluetooth_summary`, `prefs_show_error_box_title`, `prefs_show_error_box_summary`, `open_bible_links_title`, `open_bible_links_summary`, `crash_app`, `crash_app_summary`
- `bg`: `choose_strongs_greek_dictionary_title`, `choose_strongs_greek_dictionary_summary`, `choose_strongs_hebrew_dictionary_title`, `choose_strongs_hebrew_dictionary_summary`, `choose_strongs_greek_morphology_title`, `choose_strongs_greek_morphology_summary`, `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_behavior_customization_cat`, `prefs_display_customization_cat`, `prefs_advanced_settings_cat`, `prefs_open_links_in_special_window_title`, `prefs_open_links_in_special_window_summary`, `prefs_double_tap_to_fullscreen_title`, `prefs_double_tap_to_fullscreen_summary`, `auto_fullscreen`, `auto_fullscreen_summary`, `prefs_toolbar_button_action_title`, `prefs_toolbar_button_action_summary`, `prefs_disable_two_step_bookmarking_title`, `prefs_disable_two_step_bookmarking_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_night_mode_title`, `prefs_night_mode_summary`, `prefs_e_ink_mode_title`, `prefs_eink_mode_summary`, `prefs_disable_animations_title`, `prefs_disable_animations_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `full_screen_hide_buttons_pref_title`, `full_screen_hide_buttons_pref_summary`, `hide_window_buttons_title`, `hide_window_buttons_summary`, `hide_bible_reference_overlay_title`, `hide_bible_reference_overlay_summary`, `active_window_indicator_title`, `active_window_indicator_summary`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `prefs_enable_bluetooth_title`, `prefs_enable_bluetooth_summary`, `prefs_show_error_box_title`, `prefs_show_error_box_summary`, `open_bible_links_title`, `open_bible_links_summary`, `crash_app`, `crash_app_summary`
- `bn`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `crash_app`, `crash_app_summary`
- `cs`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `crash_app`, `crash_app_summary`
- `de`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `crash_app`, `crash_app_summary`
- `el`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `crash_app`, `crash_app_summary`
- `eo`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `crash_app`, `crash_app_summary`
- `es`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `crash_app`, `crash_app_summary`
- `et`: `choose_strongs_greek_dictionary_summary`, `choose_strongs_hebrew_dictionary_summary`, `choose_strongs_greek_morphology_summary`, `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_open_links_in_special_window_summary`, `prefs_toolbar_button_action_title`, `prefs_toolbar_button_action_summary`, `prefs_disable_two_step_bookmarking_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `hide_window_buttons_summary`, `hide_bible_reference_overlay_title`, `hide_bible_reference_overlay_summary`, `active_window_indicator_summary`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `prefs_show_error_box_title`, `prefs_show_error_box_summary`, `open_bible_links_summary`, `crash_app`, `crash_app_summary`
- `fi`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `crash_app`, `crash_app_summary`
- `fr`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `crash_app`, `crash_app_summary`
- `he`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `open_bible_links_summary`, `crash_app`, `crash_app_summary`
- `hi`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `prefs_enable_bluetooth_title`, `prefs_enable_bluetooth_summary`, `open_bible_links_title`, `open_bible_links_summary`, `crash_app`, `crash_app_summary`
- `hr`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `crash_app`, `crash_app_summary`
- `hu`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `crash_app`, `crash_app_summary`
- `id`: `choose_strongs_greek_dictionary_title`, `choose_strongs_greek_dictionary_summary`, `choose_strongs_hebrew_dictionary_title`, `choose_strongs_hebrew_dictionary_summary`, `choose_strongs_greek_morphology_title`, `choose_strongs_greek_morphology_summary`, `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_behavior_customization_cat`, `prefs_display_customization_cat`, `prefs_advanced_settings_cat`, `prefs_double_tap_to_fullscreen_title`, `prefs_double_tap_to_fullscreen_summary`, `auto_fullscreen_summary`, `prefs_toolbar_button_action_title`, `prefs_toolbar_button_action_summary`, `prefs_disable_two_step_bookmarking_title`, `prefs_disable_two_step_bookmarking_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_e_ink_mode_title`, `prefs_eink_mode_summary`, `prefs_disable_animations_title`, `prefs_disable_animations_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `full_screen_hide_buttons_pref_title`, `full_screen_hide_buttons_pref_summary`, `hide_window_buttons_title`, `hide_window_buttons_summary`, `hide_bible_reference_overlay_title`, `hide_bible_reference_overlay_summary`, `active_window_indicator_title`, `active_window_indicator_summary`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `prefs_enable_bluetooth_title`, `prefs_enable_bluetooth_summary`, `prefs_show_error_box_title`, `prefs_show_error_box_summary`, `open_bible_links_title`, `open_bible_links_summary`, `crash_app`, `crash_app_summary`
- `it`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `crash_app`, `crash_app_summary`
- `kk`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `crash_app`, `crash_app_summary`
- `ko`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_disable_two_step_bookmarking_title`, `prefs_disable_two_step_bookmarking_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `active_window_indicator_title`, `active_window_indicator_summary`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `prefs_enable_bluetooth_title`, `prefs_enable_bluetooth_summary`, `prefs_show_error_box_summary`, `open_bible_links_title`, `open_bible_links_summary`, `crash_app`, `crash_app_summary`
- `lt`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `crash_app`, `crash_app_summary`
- `ml`: `choose_strongs_greek_dictionary_title`, `choose_strongs_greek_dictionary_summary`, `choose_strongs_hebrew_dictionary_title`, `choose_strongs_hebrew_dictionary_summary`, `choose_strongs_greek_morphology_title`, `choose_strongs_greek_morphology_summary`, `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_behavior_customization_cat`, `prefs_display_customization_cat`, `prefs_advanced_settings_cat`, `prefs_open_links_in_special_window_title`, `prefs_open_links_in_special_window_summary`, `prefs_screen_keep_on_title`, `prefs_screen_keep_on_summary`, `prefs_double_tap_to_fullscreen_title`, `prefs_double_tap_to_fullscreen_summary`, `auto_fullscreen`, `auto_fullscreen_summary`, `prefs_toolbar_button_action_title`, `prefs_toolbar_button_action_summary`, `prefs_disable_two_step_bookmarking_title`, `prefs_disable_two_step_bookmarking_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_night_mode_title`, `prefs_night_mode_summary`, `prefs_e_ink_mode_title`, `prefs_eink_mode_summary`, `prefs_disable_animations_title`, `prefs_disable_animations_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `full_screen_hide_buttons_pref_title`, `full_screen_hide_buttons_pref_summary`, `hide_window_buttons_title`, `hide_window_buttons_summary`, `hide_bible_reference_overlay_title`, `hide_bible_reference_overlay_summary`, `active_window_indicator_title`, `active_window_indicator_summary`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `prefs_enable_bluetooth_title`, `prefs_enable_bluetooth_summary`, `prefs_show_error_box_title`, `prefs_show_error_box_summary`, `open_bible_links_title`, `open_bible_links_summary`, `crash_app`, `crash_app_summary`
- `my`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `prefs_enable_bluetooth_title`, `prefs_enable_bluetooth_summary`, `open_bible_links_title`, `open_bible_links_summary`, `crash_app`, `crash_app_summary`
- `nb`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_open_links_in_special_window_title`, `prefs_open_links_in_special_window_summary`, `prefs_toolbar_button_action_title`, `prefs_disable_two_step_bookmarking_title`, `prefs_disable_two_step_bookmarking_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `hide_window_buttons_summary`, `hide_bible_reference_overlay_title`, `hide_bible_reference_overlay_summary`, `active_window_indicator_title`, `active_window_indicator_summary`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `prefs_enable_bluetooth_summary`, `prefs_show_error_box_title`, `prefs_show_error_box_summary`, `open_bible_links_title`, `open_bible_links_summary`, `crash_app`, `crash_app_summary`
- `nl`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `crash_app`, `crash_app_summary`
- `pl`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `crash_app`, `crash_app_summary`
- `pt`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `crash_app`, `crash_app_summary`
- `pt-BR`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `prefs_experimental_features_summary`, `crash_app`, `crash_app_summary`
- `ro`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `crash_app`, `crash_app_summary`
- `ru`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `crash_app`, `crash_app_summary`
- `sk`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `crash_app`, `crash_app_summary`
- `sl`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `crash_app`, `crash_app_summary`
- `sr`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `crash_app`, `crash_app_summary`
- `sr-Latn`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `crash_app`, `crash_app_summary`
- `sv`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `crash_app`, `crash_app_summary`
- `ta`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `crash_app`, `crash_app_summary`
- `te`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `crash_app`, `crash_app_summary`
- `tr`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `crash_app`, `crash_app_summary`
- `uk`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `crash_app`, `crash_app_summary`
- `uz`: `choose_strongs_greek_dictionary_title`, `choose_strongs_greek_dictionary_summary`, `choose_strongs_hebrew_dictionary_title`, `choose_strongs_hebrew_dictionary_summary`, `choose_strongs_greek_morphology_title`, `choose_strongs_greek_morphology_summary`, `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_behavior_customization_cat`, `prefs_display_customization_cat`, `prefs_advanced_settings_cat`, `prefs_open_links_in_special_window_title`, `prefs_open_links_in_special_window_summary`, `prefs_double_tap_to_fullscreen_title`, `prefs_double_tap_to_fullscreen_summary`, `auto_fullscreen`, `auto_fullscreen_summary`, `prefs_toolbar_button_action_title`, `prefs_toolbar_button_action_summary`, `prefs_disable_two_step_bookmarking_title`, `prefs_disable_two_step_bookmarking_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_night_mode_title`, `prefs_night_mode_summary`, `prefs_e_ink_mode_title`, `prefs_eink_mode_summary`, `prefs_disable_animations_title`, `prefs_disable_animations_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `full_screen_hide_buttons_pref_title`, `full_screen_hide_buttons_pref_summary`, `hide_window_buttons_title`, `hide_window_buttons_summary`, `hide_bible_reference_overlay_title`, `hide_bible_reference_overlay_summary`, `active_window_indicator_title`, `active_window_indicator_summary`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `prefs_enable_bluetooth_title`, `prefs_enable_bluetooth_summary`, `prefs_show_error_box_title`, `prefs_show_error_box_summary`, `open_bible_links_title`, `open_bible_links_summary`, `crash_app`, `crash_app_summary`
- `yue`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `crash_app`, `crash_app_summary`
- `zh-Hans`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `crash_app`, `crash_app_summary`
- `zh-Hant`: `choose_word_lookup_dictionary_title`, `choose_word_lookup_dictionary_summary`, `prefs_bible_view_swipe_mode_title`, `prefs_bible_view_swipe_mode_summary`, `prefs_volume_keys_scroll_title`, `prefs_volume_keys_scroll_summary`, `prefs_disable_click_to_edit_title`, `prefs_disable_click_to_edit_summary`, `pref_font_size_multiplier_title`, `prefs_experimental_features_title`, `prefs_experimental_features_summary`, `crash_app`, `crash_app_summary`

## iOS-vs-Android Translation Gaps

- None. No locale/key remains English in iOS where Android has a non-English translation.
