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


xml_files = [APP / "AndroidManifest.xml"] + sorted((APP / "res").rglob("*.xml"))
roots = {}
resources = {}
for path in xml_files:
    try:
        root = ET.parse(path).getroot()
    except (ET.ParseError, OSError) as exc:
        fail(f"invalid XML at {path.relative_to(ROOT)}: {exc}")
    roots[path] = root
    if path != APP / "AndroidManifest.xml":
        if root.tag != "resources":
            fail(f"{path.relative_to(ROOT)} must have a resources root")
        for element in list(root):
            name = element.get("name")
            if not name:
                fail(f"unnamed resource in {path.relative_to(ROOT)}")
            resources.setdefault(element.tag, set()).add(name)

manifest = roots[APP / "AndroidManifest.xml"]
java_path = APP / "src/com/jalvoro/settings/MainActivity.java"
java = java_path.read_text(encoding="utf-8")
for source in [APP / "AndroidManifest.xml", java_path] + [p for p in xml_files if p != APP / "AndroidManifest.xml"]:
    content = source.read_text(encoding="utf-8")
    for kind, name in re.findall(r"@(string|color|style)/([A-Za-z0-9_]+)", content):
        if name not in resources.get(kind, set()):
            fail(f"{source.relative_to(ROOT)} references missing {kind} '{name}'")
    for kind, name in re.findall(r"R\.(string|color|style)\.([A-Za-z0-9_]+)", content):
        if name not in resources.get(kind, set()):
            fail(f"{source.relative_to(ROOT)} references missing {kind} '{name}'")

if "android.intent.category.LAUNCHER" not in manifest.read_text(encoding="utf-8"):
    fail("Settings app has no launcher intent filter")
if "openSystemPage(action)" not in java:
    fail("Settings cards are not wired to Android settings actions")

print(f"Settings XML valid; {sum(len(v) for v in resources.values())} resource definitions; references passed.")
print("Note: this is not an AOSP/Soong compile.")
