#!/usr/bin/env python3
"""Validate basic XML and string-resource consistency for Jalvoro Launcher.

This is a source-level check only; it does not replace aapt2, Soong, or an AOSP build.
"""
from pathlib import Path
import re
import sys
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / "packages/apps/JalvoroLauncher"
ANDROID_NS = "{http://schemas.android.com/apk/res/android}"


def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(1)


manifest_path = APP / "AndroidManifest.xml"
strings_path = APP / "res/values/strings.xml"

try:
    manifest = ET.parse(manifest_path).getroot()
except (ET.ParseError, OSError) as exc:
    fail(f"invalid AndroidManifest.xml: {exc}")

try:
    strings_root = ET.parse(strings_path).getroot()
except (ET.ParseError, OSError) as exc:
    fail(f"invalid strings.xml: {exc}")

if manifest.tag != "manifest":
    fail("manifest root element is missing")
if strings_root.tag != "resources":
    fail("strings.xml must have a resources root")

names = []
for item in strings_root.findall("string"):
    name = item.get("name")
    if not name:
        fail("string resource without a name")
    names.append(name)
if len(names) != len(set(names)):
    fail("duplicate string resource names")
known = set(names)

# Validate references used in manifest and Java sources.
for source in (manifest_path, APP / "src/com/jalvoro/launcher/MainActivity.java"):
    content = source.read_text(encoding="utf-8")
    for name in re.findall(r"@string/([A-Za-z0-9_]+)", content):
        if name not in known:
            fail(f"{source.relative_to(ROOT)} references missing string '{name}'")
    for name in re.findall(r"R\.string\.([A-Za-z0-9_]+)", content):
        if name not in known:
            fail(f"{source.relative_to(ROOT)} references missing string '{name}'")

queries = manifest.find("queries")
if queries is None:
    fail("manifest needs scoped <queries> visibility for launcher apps")
if not any(
    intent.find("action") is not None
    and intent.find("action").get(ANDROID_NS + "name") == "android.intent.action.MAIN"
    and intent.find("category") is not None
    and intent.find("category").get(ANDROID_NS + "name") == "android.intent.category.LAUNCHER"
    for intent in queries.findall("intent")
):
    fail("manifest query must match MAIN + LAUNCHER")

print(f"Android XML valid; {len(known)} unique strings; resource references and launcher visibility passed.")
print("Note: this is not an AOSP/Soong compile.")
