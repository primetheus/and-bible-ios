#!/usr/bin/env python3
"""Boot an iOS simulator and fail fast with diagnostics if boot never completes."""

from __future__ import annotations

import argparse
import subprocess
import sys


def dump_diagnostics() -> None:
    diagnostic_commands = [
        ["xcrun", "simctl", "list", "devices", "available"],
        ["xcrun", "simctl", "list", "runtimes", "available"],
    ]
    for command in diagnostic_commands:
        print(f"Diagnostic command: {' '.join(command)}")
        result = subprocess.run(command, capture_output=True, text=True)
        if result.stdout:
            print(result.stdout)
        if result.stderr:
            print(result.stderr)


def wait_for_boot(simulator_id: str, timeout_seconds: int) -> int:
    command = ["xcrun", "simctl", "bootstatus", simulator_id, "-b"]
    try:
        result = subprocess.run(command, capture_output=True, text=True, timeout=timeout_seconds)
    except subprocess.TimeoutExpired:
        print(f"Simulator {simulator_id} did not finish booting within {timeout_seconds} seconds.")
        dump_diagnostics()
        return 1

    if result.stdout:
        print(result.stdout)
    if result.stderr:
        print(result.stderr)

    if result.returncode != 0:
        print(f"simctl bootstatus exited with status {result.returncode}")
        dump_diagnostics()
        return result.returncode

    return 0


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--simulator-id", required=True, help="Simulator UDID")
    parser.add_argument("--timeout-seconds", type=int, default=300, help="Boot wait timeout")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    return wait_for_boot(args.simulator_id, args.timeout_seconds)


if __name__ == "__main__":
    sys.exit(main())
