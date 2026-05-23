import sys
import os
import re

def log(msg):
    print(f"PATCHER: {msg}", flush=True)

def get_tag_for_keyword(kw):
    kw_upper = kw.upper()
    if kw_upper == "FIXME":
        return "tag_fixme"
    elif kw_upper in ["WARN", "HACK"]:
        return "tag_warning"
    elif kw_upper in ["TODO", "NOTE", "INFO", "OPTIM", "PERF", "BUG", "IDEA", "WIP", "TASK", "XXX"]:
        return "tag_todo"
    else:
        log(f"WARNING: No specific style for '{kw}'")
        return "tag_todo"

def patch_fea(file_path, extra_escape, pill_keywords, disable_alt_pill):
    log(f"Patching FEA: {file_path}")

    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    # 1. Extra escape patch
    if extra_escape:
        def add_escape(match):
            head = match.group(1)
            body = match.group(2).rstrip()
            tail = match.group(3)
            added = " ".join(extra_escape)
            return head + body + " " + added + " " + tail

        escape_pattern = re.compile(r"(@Escape\s*=\s*\[)([^\]]*)(\];)", re.DOTALL)
        content = escape_pattern.sub(add_escape, content)

    # 2. Disable alt pills
    if disable_alt_pill:
        content = re.sub(r"lookup tag_.*_alt \{.*?\} tag_.*_alt;", "", content, flags=re.DOTALL)

    # 3. Add custom pill lookups
    new_lookups = []
    if pill_keywords:
        for kw in pill_keywords:
            liga = get_tag_for_keyword(kw)
            if liga:
                kw_lower = kw.lower()
                lookup_name = f"tag_custom_{kw_lower}"
                if lookup_name not in content:
                    chars_all = " ".join(kw)
                    l = f" lookup {lookup_name} {{\n"
                    l += f"  sub bracketleft' {chars_all} bracketright by {liga}.liga;\n"
                    l += f" }} {lookup_name};\n"
                    new_lookups.append(l)
                    log(f"Added lookup for {kw} -> {liga}")

    # Insert at top of calt
    if new_lookups:
        joined = "".join(new_lookups)
        insert_str = f"feature calt {{\n{joined}\n"
        content = content.replace("feature calt {", insert_str, 1)
        log(f"Inserted {len(new_lookups)} lookups")

    with open(file_path, "w", encoding="utf-8") as f:
        f.write(content)

def patch_build_py(file_path):
    log(f"Patching {file_path}...")
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Add --style argument (if not present)
    if "--style" not in content:
        content = content.replace(
            'parser.add_argument("--least-styles", action="store_true", help="least styles")',
            'parser.add_argument("--least-styles", action="store_true", help="least styles")\n    parser.add_argument("--style", help="build specific style")'
        )
        log("Added --style argument")

    with open(file_path, "w", encoding="utf-8", newline="\n") as f:
        f.write(content)

if __name__ == "__main__":
    log("Patch script started")
    if len(sys.argv) < 4:
        log("Insufficient arguments")
        sys.exit(1)

    extra_escape = sys.argv[1].split(",") if sys.argv[1] else []
    pill_keywords = sys.argv[2].split(",") if sys.argv[2] else []
    disable_alt_pill = sys.argv[3] == "1"

    fea_files = [
        "source/features/regular.fea",
        "source/features/italic.fea",
        "source/features/regular_cn.fea",
        "source/features/italic_cn.fea"
    ]

    for f in fea_files:
        if os.path.exists(f):
            patch_fea(f, extra_escape, pill_keywords, disable_alt_pill)

    if os.path.exists("build.py"):
        patch_build_py("build.py")

    log("Patch script finished")
