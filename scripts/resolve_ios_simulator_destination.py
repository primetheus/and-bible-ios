#!/usr/bin/env python3
"""Resolve a preferred iOS simulator destination for GitHub Actions builds."""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
import time
from pathlib import Path


DEFAULT_PREFERRED_ORDER = [
    "iPhone 17",
    "iPhone 16 Pro",
    "iPhone 16",
    "iPhone 15 Pro",
    "iPhone 15",
]


def parse_candidates(text: str) -> list[tuple[str, str, str]]:
    candidates: list[tuple[str, str, str]] = []
    for raw_line in text.splitlines():
        line = raw_line.strip()
        if "{ platform:iOS Simulator" not in line:
            continue
        if not (line.startswith("{") and line.endswith("}")):
            continue

        parts = [part.strip() for part in line[1:-1].split(",")]
        fields: dict[str, str] = {}
        for part in parts:
            if ":" not in part:
                continue
            key, value = part.split(":", 1)
            fields[key.strip()] = value.strip()

        name = fields.get("name", "")
        simulator_id = fields.get("id", "")
        os_version = fields.get("OS", "")
        platform = fields.get("platform", "")

        if platform != "iOS Simulator":
            continue
        if name == "Any iOS Simulator Device":
            continue
        if simulator_id.startswith("dvtdevice-"):
            continue
        if not name.startswith("iPhone"):
            continue

        candidates.append((name, os_version, simulator_id))

    return candidates


def choose_candidate(
    candidates: list[tuple[str, str, str]],
    preferred_order: list[str] | None = None,
) -> tuple[str, str, str]:
    if not candidates:
        raise ValueError("No iPhone simulator candidates were found")

    preferred = preferred_order or DEFAULT_PREFERRED_ORDER
    for preferred_name in preferred:
        for candidate in candidates:
            if candidate[0] == preferred_name:
                return candidate
    return candidates[0]


def discover_candidates(project: str, scheme: str, retries: int, delay_seconds: float) -> tuple[list[tuple[str, str, str]], str]:
    command = [
        "xcodebuild",
        "-project",
        project,
        "-scheme",
        scheme,
        "-showdestinations",
    ]

    output_text = ""
    candidates: list[tuple[str, str, str]] = []
    for attempt in range(1, retries + 1):
        result = subprocess.run(command, capture_output=True, text=True)
        output_text = f"{result.stdout}\n{result.stderr}"
        candidates = parse_candidates(output_text)
        if result.returncode == 0 and candidates:
            break

        print(f"showdestinations attempt {attempt} failed; retrying")
        print(output_text)
        if attempt < retries:
            time.sleep(delay_seconds)

    return candidates, output_text


def write_github_output(output_path: Path, destination: str, device_name: str, os_version: str) -> None:
    with output_path.open("a", encoding="utf-8") as file_handle:
        file_handle.write(f"destination={destination}\n")
        file_handle.write(f"device_name={device_name}\n")
        file_handle.write(f"os_version={os_version}\n")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--project", default="AndBible.xcodeproj", help="Xcode project path")
    parser.add_argument("--scheme", default="AndBible", help="Xcode scheme name")
    parser.add_argument("--retries", type=int, default=3, help="Number of xcodebuild retries")
    parser.add_argument("--delay-seconds", type=float, default=2.0, help="Delay between retries")
    parser.add_argument(
        "--github-output",
        default=os.environ.get("GITHUB_OUTPUT"),
        help="Path to the GitHub Actions output file; defaults to GITHUB_OUTPUT",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    candidates, output_text = discover_candidates(
        project=args.project,
        scheme=args.scheme,
        retries=args.retries,
        delay_seconds=args.delay_seconds,
    )

    if not candidates:
        print("Unable to discover iPhone simulators from xcodebuild -showdestinations output")
        print(output_text)
        return 1

    name, os_version, simulator_id = choose_candidate(candidates)
    destination = f"id={simulator_id}"

    print(f"Selected simulator: {name} (iOS {os_version})")

    if not args.github_output:
        print("GITHUB_OUTPUT is not set and no --github-output path was provided", file=sys.stderr)
        return 1

    write_github_output(Path(args.github_output), destination, name, os_version)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())