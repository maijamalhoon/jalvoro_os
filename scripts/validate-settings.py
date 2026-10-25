#!/usr/bin/env python3
"""Validate Jalvoro Settings Android XML and resource references (not a full build)."""
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
xml_files = [manifest_path] + sorted((APP / "res").rglob("*.xml"))
roots = {}
resources = {}
for path in xml_files:
    try:
        root = ET.parse(path).getroot()
    except (ET.ParseError, OSError) as exc:
        fail(f"invalid XML at {path.relative_to(ROOT)}: {exc}")
    roots[path] = root
    if path != manifest_path:
        if root.tag != "resources":
            fail(f"{path.relative_to(ROOT)} must have a resources root")
        for element in list(root):
            name = element.get("name")
            if not name:
                fail(f"unnamed resource in {path.relative_to(ROOT)}")
            resources.setdefault(element.tag, set()).add(name)

manifest = roots[manifest_path]
java_path = APP / "src/com/jalvoro/settings/MainActivity.java"
java = java_path.read_text(encoding="utf-8")
for source in [manifest_path, java_path] + [p for p in xml_files if p != manifest_path]:
    content = source.read_text(encoding="utf-8")
    for kind, name in re.findall(r"@(string|color|style)/([A-Za-z0-9_]+)", content):
        if name not in resources.get(kind, set()):
            fail(f"{source.relative_to(ROOT)} references missing {kind} '{name}'")
    for kind, name in re.findall(r"R\.(string|color|style)\.([A-Za-z0-9_]+)", content):
        if name not in resources.get(kind, set()):
            fail(f"{source.relative_to(ROOT)} references missing {kind} '{name}'")

bp_path = APP / "Android.bp"
if "privileged: false" not in bp_path.read_text(encoding="utf-8"):
    fail("Settings hub must remain non-privileged unless a reviewed system feature requires otherwise")
if "android.intent.category.LAUNCHER" not in manifest_path.read_text(encoding="utf-8"):
    fail("Settings app has no launcher intent filter")
if "scroll.setBackgroundColor(color(R.color.settings_background))" not in java:
    fail("Settings root background must use a declared theme color resource")
if "CANVAS" in java:
    fail("Settings source contains an unresolved CANVAS symbol")
if "openSystemPage(action)" not in java:
    fail("Settings cards are not wired to Android settings actions")

print(f"Settings XML valid; {sum(len(v) for v in resources.values())} resource definitions; references passed.")
print("Note: this is not an AOSP/Soong compile.")
