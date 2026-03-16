import unittest
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))

from resolve_ios_simulator_destination import choose_candidate, parse_candidates


class ResolveIosSimulatorDestinationTests(unittest.TestCase):
    def test_parse_candidates_filters_to_real_iphone_simulators(self) -> None:
        text = "\n".join(
            [
                "{ platform:iOS Simulator, id:dvtdevice-DVTiOSDeviceSimulatorPlaceholder-iphonesimulator:placeholder, OS:18.2, name:Any iOS Simulator Device }",
                "{ platform:iOS Simulator, id:ABC-123, OS:18.2, name:iPhone 16 Pro }",
                "{ platform:iOS Simulator, id:DEF-456, OS:18.2, name:iPad Pro (13-inch) (M4) }",
                "{ platform:macOS, id:MAC-1, name:My Mac }",
            ]
        )

        self.assertEqual(parse_candidates(text), [("iPhone 16 Pro", "18.2", "ABC-123")])

    def test_choose_candidate_prefers_known_devices(self) -> None:
        candidates = [
            ("iPhone 15", "17.5", "ID-15"),
            ("iPhone 16 Pro", "18.2", "ID-16P"),
        ]

        self.assertEqual(choose_candidate(candidates), ("iPhone 16 Pro", "18.2", "ID-16P"))

    def test_choose_candidate_falls_back_to_first_available(self) -> None:
        candidates = [
            ("iPhone 14", "17.4", "ID-14"),
            ("iPhone 13 mini", "17.4", "ID-13M"),
        ]

        self.assertEqual(choose_candidate(candidates), ("iPhone 14", "17.4", "ID-14"))


if __name__ == "__main__":
    unittest.main()
