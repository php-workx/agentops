#!/usr/bin/env python3
"""
Screenshot Wrapper for AgentOps Multimodal Workflows

Purpose: Python wrapper around screenshot.js for easy integration with Claude Code
Usage: python screenshot_wrapper.py <url> <output-path> [options]

Examples:
    python screenshot_wrapper.py http://localhost:3000 /tmp/ui.png
    python screenshot_wrapper.py http://localhost:3000 /tmp/mobile.png --viewport 375x667
    python screenshot_wrapper.py http://localhost:3000 /tmp/stable.png --wait 2000

Options:
    --viewport <width>x<height>  Set viewport size (default: 1280x720)
    --wait <ms>                  Wait time after load (default: 500ms)
    --full-page                  Capture full scrollable page
    --timeout <ms>               Page load timeout (default: 30000ms)
"""

import sys
import subprocess
import os
import json
from pathlib import Path


def find_screenshot_js():
    """Find screenshot.js in the same directory as this script."""
    script_dir = Path(__file__).parent
    screenshot_js = script_dir / "screenshot.js"

    if not screenshot_js.exists():
        raise FileNotFoundError(
            f"screenshot.js not found at {screenshot_js}. "
            "Ensure screenshot.js is in the same directory as this script."
        )

    return str(screenshot_js)


def validate_args(args):
    """Validate command line arguments."""
    if len(args) < 3:  # script name + url + output
        print("Usage: python screenshot_wrapper.py <url> <output-path> [options]", file=sys.stderr)
        print("", file=sys.stderr)
        print("Options:", file=sys.stderr)
        print("  --viewport <width>x<height>  Viewport size (default: 1280x720)", file=sys.stderr)
        print("  --wait <ms>                  Wait after load (default: 500)", file=sys.stderr)
        print("  --full-page                  Capture full page", file=sys.stderr)
        print("  --timeout <ms>               Load timeout (default: 30000)", file=sys.stderr)
        sys.exit(1)


def run_screenshot(url, output_path, options=None):
    """
    Run screenshot.js with the given parameters.

    Args:
        url: URL to screenshot
        output_path: Where to save the screenshot
        options: Optional dict of options (viewport, wait, full_page, timeout)

    Returns:
        dict: Result with success status and metadata
    """
    if options is None:
        options = {}

    # Find screenshot.js
    screenshot_js = find_screenshot_js()

    # Build command
    cmd = ["node", screenshot_js, url, output_path]

    # Add optional parameters
    if "viewport" in options:
        cmd.extend(["--viewport", options["viewport"]])

    if "wait" in options:
        cmd.extend(["--wait", str(options["wait"])])

    if options.get("full_page", False):
        cmd.append("--full-page")

    if "timeout" in options:
        cmd.extend(["--timeout", str(options["timeout"])])

    # Run command
    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            check=True
        )

        # Parse output for metadata
        output_lines = result.stdout.strip().split("\n")

        return {
            "success": True,
            "path": output_path,
            "stdout": result.stdout,
            "stderr": result.stderr
        }

    except subprocess.CalledProcessError as e:
        return {
            "success": False,
            "error": e.stderr,
            "stdout": e.stdout,
            "exit_code": e.returncode
        }

    except Exception as e:
        return {
            "success": False,
            "error": str(e)
        }


def main():
    """Main CLI entry point."""
    # Validate arguments
    validate_args(sys.argv)

    # Parse arguments
    url = sys.argv[1]
    output_path = sys.argv[2]

    # Parse options
    options = {}
    i = 3
    while i < len(sys.argv):
        arg = sys.argv[i]

        if arg == "--viewport" and i + 1 < len(sys.argv):
            options["viewport"] = sys.argv[i + 1]
            i += 2
        elif arg == "--wait" and i + 1 < len(sys.argv):
            options["wait"] = int(sys.argv[i + 1])
            i += 2
        elif arg == "--full-page":
            options["full_page"] = True
            i += 1
        elif arg == "--timeout" and i + 1 < len(sys.argv):
            options["timeout"] = int(sys.argv[i + 1])
            i += 2
        else:
            i += 1

    # Run screenshot
    result = run_screenshot(url, output_path, options)

    # Print output
    if result["success"]:
        print(result["stdout"], end="")
        sys.exit(0)
    else:
        print(result.get("error", "Unknown error"), file=sys.stderr)
        if "stdout" in result:
            print(result["stdout"], end="")
        sys.exit(1)


if __name__ == "__main__":
    main()
