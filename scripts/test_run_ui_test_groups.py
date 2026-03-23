"""Tests for run_ui_test_groups."""

from __future__ import annotations

import json
import os
import pathlib
import subprocess
import sys
import tempfile
import unittest
from unittest import mock

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))

from run_ui_test_groups import (
    DEFAULT_BUNDLE_IDENTIFIER,
    create_argument_parser,
    derive_group_result_bundle_path,
    group_selection_args_by_fixture,
    install_app_with_retry,
    infer_app_path,
    load_fixture_manifest,
    main,
    selection_arg_to_identifier,
    terminate_app_if_running,
)


class SelectionArgTests(unittest.TestCase):
    def test_selection_arg_to_identifier_extracts_xctest_identifier(self) -> None:
        self.assertEqual(
            selection_arg_to_identifier(
                "-only-testing:AndBibleUITests/AndBibleUITests/testBookmarkSelectionNavigatesReaderToSeededReference"
            ),
            "AndBibleUITests/AndBibleUITests/testBookmarkSelectionNavigatesReaderToSeededReference",
        )

    def test_selection_arg_to_identifier_rejects_non_only_testing_argument(self) -> None:
        with self.assertRaises(ValueError):
            selection_arg_to_identifier("-skip-testing:AndBibleUITests/AndBibleUITests/testOne")


class FixtureManifestTests(unittest.TestCase):
    def test_load_fixture_manifest_requires_non_empty_string_values(self) -> None:
        with tempfile.TemporaryDirectory() as temp_dir:
            manifest_path = pathlib.Path(temp_dir) / "manifest.json"
            manifest_path.write_text(json.dumps({"AndBibleUITests/AndBibleUITests/testOne": ""}))
            with self.assertRaises(ValueError):
                load_fixture_manifest(manifest_path)

    def test_group_selection_args_by_fixture_preserves_selection_order_within_scenarios(self) -> None:
        selection_args = [
            "-only-testing:AndBibleUITests/AndBibleUITests/testBookmarkSelectionNavigatesReaderToSeededReference",
            "-only-testing:AndBibleUITests/AndBibleUITests/testHistorySelectionNavigatesReaderToSeededReference",
            "-only-testing:AndBibleUITests/AndBibleUITests/testBookmarkRowDeletePreservesOtherRowsAcrossReopen",
        ]
        manifest = {
            "AndBibleUITests/AndBibleUITests/testBookmarkSelectionNavigatesReaderToSeededReference": "bookmark-navigation",
            "AndBibleUITests/AndBibleUITests/testHistorySelectionNavigatesReaderToSeededReference": "history-single",
            "AndBibleUITests/AndBibleUITests/testBookmarkRowDeletePreservesOtherRowsAcrossReopen": "bookmark-multirow",
        }
        self.assertEqual(
            group_selection_args_by_fixture(selection_args, manifest),
            [
                (
                    "bookmark-navigation",
                    [
                        "-only-testing:AndBibleUITests/AndBibleUITests/testBookmarkSelectionNavigatesReaderToSeededReference"
                    ],
                ),
                (
                    "history-single",
                    [
                        "-only-testing:AndBibleUITests/AndBibleUITests/testHistorySelectionNavigatesReaderToSeededReference"
                    ],
                ),
                (
                    "bookmark-multirow",
                    [
                        "-only-testing:AndBibleUITests/AndBibleUITests/testBookmarkRowDeletePreservesOtherRowsAcrossReopen"
                    ],
                ),
            ],
        )

    def test_group_selection_args_by_fixture_requires_manifest_entry_for_every_selected_test(self) -> None:
        with self.assertRaises(ValueError):
            group_selection_args_by_fixture(
                ["-only-testing:AndBibleUITests/AndBibleUITests/testOne"],
                {},
            )


class PathDerivationTests(unittest.TestCase):
    def test_derive_group_result_bundle_path_suffixes_multi_group_paths(self) -> None:
        derived = derive_group_result_bundle_path(
            pathlib.Path(".artifacts/AndBibleTests-ui.xcresult"),
            scenario="bookmark-filter",
            group_index=2,
            total_groups=3,
        )
        self.assertEqual(
            derived,
            pathlib.Path(".artifacts/AndBibleTests-ui-group-02-bookmark-filter.xcresult"),
        )

    def test_infer_app_path_uses_configuration_and_scheme(self) -> None:
        self.assertEqual(
            infer_app_path(
                derived_data_path=pathlib.Path(".derivedData"),
                configuration="Debug",
                scheme="AndBible",
            ),
            pathlib.Path(".derivedData/Build/Products/Debug-iphonesimulator/AndBible.app"),
        )


class SimctlTerminationTests(unittest.TestCase):
    def test_terminate_app_if_running_continues_after_timeout(self) -> None:
        with mock.patch(
            "run_ui_test_groups.subprocess.run",
            side_effect=subprocess.TimeoutExpired(cmd=["xcrun", "simctl", "terminate"], timeout=15),
        ) as run_mock:
            with mock.patch("run_ui_test_groups.print") as print_mock:
                terminate_app_if_running(
                    simulator_id="SIM-1",
                    bundle_identifier="org.andbible.ios",
                    timeout_seconds=15,
                )

        run_mock.assert_called_once()
        print_mock.assert_any_call(
            "Running: xcrun simctl terminate SIM-1 org.andbible.ios (best-effort)",
            flush=True,
        )
        print_mock.assert_any_call(
            "simctl terminate timed out after 15s for org.andbible.ios; continuing.",
            flush=True,
        )

    def test_install_app_with_retry_retries_after_timeout(self) -> None:
        with mock.patch(
            "run_ui_test_groups.run_command",
            side_effect=[
                subprocess.TimeoutExpired(cmd=["xcrun", "simctl", "install"], timeout=120),
                mock.Mock(),
            ],
        ) as run_command_mock:
            with mock.patch("run_ui_test_groups.terminate_app_if_running") as terminate_mock:
                with mock.patch("run_ui_test_groups.uninstall_app_if_installed") as uninstall_mock:
                    install_app_with_retry(
                        simulator_id="SIM-1",
                        app_path=pathlib.Path("/tmp/AndBible.app"),
                        bundle_identifier="org.andbible.ios",
                    )

        self.assertEqual(run_command_mock.call_count, 2)
        terminate_mock.assert_called_once_with(
            simulator_id="SIM-1",
            bundle_identifier="org.andbible.ios",
        )
        uninstall_mock.assert_called_once_with(
            simulator_id="SIM-1",
            bundle_identifier="org.andbible.ios",
        )

    def test_install_app_with_retry_raises_after_second_failure(self) -> None:
        failure = subprocess.CalledProcessError(
            returncode=1,
            cmd=["xcrun", "simctl", "install"],
        )
        with mock.patch(
            "run_ui_test_groups.run_command",
            side_effect=[failure, failure],
        ):
            with mock.patch("run_ui_test_groups.terminate_app_if_running"):
                with mock.patch("run_ui_test_groups.uninstall_app_if_installed"):
                    with self.assertRaises(subprocess.CalledProcessError):
                        install_app_with_retry(
                            simulator_id="SIM-1",
                            app_path=pathlib.Path("/tmp/AndBible.app"),
                            bundle_identifier="org.andbible.ios",
                        )


class CliTests(unittest.TestCase):
    def test_main_reads_selection_args_from_environment_when_flag_is_omitted(self) -> None:
        argv = [
            "--project", "AndBible.xcodeproj",
            "--scheme", "AndBible",
            "--configuration", "Debug",
            "--destination", "id=SIM-1",
            "--simulator-id", "SIM-1",
            "--derived-data-path", ".derivedData",
            "--result-bundle-path", ".artifacts/AndBibleTests-ui.xcresult",
            "--fixture-manifest", "scripts/ui_test_fixture_manifest.json",
            "--fixture-tool-path", ".build/debug/UITestFixtureTool",
        ]
        with mock.patch.dict(os.environ, {"TEST_SELECTION_ARGS": "-only-testing:AndBibleUITests/AndBibleUITests/testOne"}):
            with mock.patch("run_ui_test_groups.run_grouped_ui_tests", return_value=0) as runner:
                self.assertEqual(main(argv), 0)

        runner.assert_called_once()
        self.assertEqual(
            runner.call_args.kwargs["selection_args_text"],
            "-only-testing:AndBibleUITests/AndBibleUITests/testOne",
        )

    def test_parser_defaults_bundle_identifier(self) -> None:
        parser = create_argument_parser()
        args = parser.parse_args(
            [
                "--project", "AndBible.xcodeproj",
                "--scheme", "AndBible",
                "--configuration", "Debug",
                "--destination", "id=SIM-1",
                "--simulator-id", "SIM-1",
                "--derived-data-path", ".derivedData",
                "--result-bundle-path", ".artifacts/AndBibleTests-ui.xcresult",
                "--fixture-manifest", "scripts/ui_test_fixture_manifest.json",
                "--fixture-tool-path", ".build/debug/UITestFixtureTool",
            ]
        )
        self.assertEqual(args.bundle_id, DEFAULT_BUNDLE_IDENTIFIER)


if __name__ == "__main__":
    unittest.main()
