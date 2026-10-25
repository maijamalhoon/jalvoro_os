#!/usr/bin/env python3
"""Validate Jalvoro Launcher Android XML and resource references (not a full build)."""
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
java_path = APP / "src/com/jalvoro/launcher/MainActivity.java"
java = java_path.read_text(encoding="utf-8")
for source in [APP / "AndroidManifest.xml", java_path] + [p for p in xml_files if p != APP / "AndroidManifest.xml"]:
    content = source.read_text(encoding="utf-8")
    for kind, name in re.findall(r"@(string|color|style)/([A-Za-z0-9_]+)", content):
        if name not in resources.get(kind, set()):
            fail(f"{source.relative_to(ROOT)} references missing {kind} '{name}'")
    for kind, name in re.findall(r"R\.(string|color|style)\.([A-Za-z0-9_]+)", content):
        if name not in resources.get(kind, set()):
            fail(f"{source.relative_to(ROOT)} references missing {kind} '{name}'")

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

print(f"Launcher XML valid; {sum(len(v) for v in resources.values())} resource definitions; references and package visibility passed.")
print("Note: this is not an AOSP/Soong compile.")
