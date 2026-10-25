#!/usr/bin/env python3
"""Static XML and resource-reference checks for Jalvoro Settings."""
from pathlib import Path
import re
import sys
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / "packages/apps/JalvoroSettings"


def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(1)


manifest_path = APP / "AndroidManifest.xml"
strings_path = APP / "res/values/strings.xml"
try:
    manifest = ET.parse(manifest_path).getroot()
    resources = ET.parse(strings_path).getroot()
except (ET.ParseError, OSError) as exc:
    fail(f"invalid Android XML: {exc}")

if manifest.tag != "manifest" or resources.tag != "resources":
    fail("unexpected Android XML root element")
names = [item.get("name") for item in resources.findall("string")]
if any(not name for name in names):
    fail("unnamed string resource found")
if len(names) != len(set(names)):
    fail("duplicate string resource names")
known = set(names)

java_path = APP / "src/com/jalvoro/settings/MainActivity.java"
java = java_path.read_text(encoding="utf-8")
for source in (manifest_path, java_path):
    content = source.read_text(encoding="utf-8")
    for name in re.findall(r"@string/([A-Za-z0-9_]+)", content):
        if name not in known:
            fail(f"{source.relative_to(ROOT)} references missing string '{name}'")
    for name in re.findall(r"R\.string\.([A-Za-z0-9_]+)", content):
        if name not in known:
            fail(f"{source.relative_to(ROOT)} references missing string '{name}'")

if "android.intent.category.LAUNCHER" not in manifest_path.read_text(encoding="utf-8"):
    fail("Settings app has no launcher intent filter")
if "openSystemPage(action)" not in java:
    fail("Settings cards are not wired to Android settings actions")

print(f"Jalvoro Settings XML valid; {len(known)} unique strings; resource references passed.")
print("Note: this is not an AOSP/Soong compile.")
