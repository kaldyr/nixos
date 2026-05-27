import sys
import os
import re
import logging
import shutil

logger = logging.getLogger(__name__)
logging.basicConfig( level=logging.INFO,
                     format="%(asctime)s - [%(levelname)s] - %(message)s",
                     handlers=[
                         logging.FileHandler("patch.log"),
                         logging.StreamHandler()
                     ])

def patch_fea( file_path, extra_escape, pill_keywords, disable_alt_pill ):
    logger.info( f"Patching feature: {file_path}" )

    content = ""
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Patch Escape Lookup
    if extra_escape:
        escape_pattern = re.compile( r"(@Escape\s*=\s*\[)([^\]]*)(\];)", re.DOTALL )
        def add_escape(match):
            head = match.group(1)
            body = match.group(2).rstrip()
            tail = match.group(3)
            added = " ".join(extra_escape)
            return head + body + " " + added + " " + tail
        content = escape_pattern.sub( add_escape, content )

    # Disable alt pills
    if disable_alt_pill:
      content = re.sub( r"lookup tag_.*_alt \{.*?\} tag_todo_alt;", "", content, re.DOTALL )
      content = re.sub( r"lookup tag_.*_alt;", "", content )

    # Add new pills
    new_lookups = []
    if pill_keywords:
        for kw in pill_keywords:
            kw_lower = kw.lower()
            lookup_name = f"tag_custom_{kw_lower}"

            if lookup_name not in content:
                chars_all = " " + " ".join(kw) + " "
                logger.info( f"chars_all = {chars_all}" )
                l = f"  lookup {lookup_name} {{\n"
                l += f"    sub bracketleft' {chars_all} bracketright by tag_todo.liga;\n"
                l += f"  }} {lookup_name};\n"
                new_lookups.append(l)
                logger.info( f"Added [{kw}] → pill" )

        if new_lookups:
            joined = "".join(new_lookups)
            insert_str = f"feature calt {{\n{joined}\n"
            content = content.replace("feature calt {", insert_str, 1)
            logger.info( f"Inserted {len(new_lookups)} lookups" )

        with open(file_path, "w", encoding="utf-8") as f:
            f.write(content)

def patch_build():
    logger.info( "Patching build.py..." )
    with open( "build.py", "r", encoding="utf-8" ) as f:
        content = f.read()

    # Add --style content
    if "--style" not in content:
        content = content.replace(
            'parser.add_argument("--least-styles", action="store_true", help="least styles")',
            'parser.add_argument("--least-styles", action="store_true", help="least styles")\n    parser.add_argument("--style", help="build specific style")'
        )
        logger.info( "Added --style argument" )

    # Patch target_styles
    lines = content.splitlines()
    new_lines = []
    patched = False
    target_regex = re.compile( r"target_styles\s*=\s*\(" )

    for l in lines:
        if not patched and target_regex.search(l):
            logger.info( f"Found target_styles on line: {l}" )
            indent = l.split( "target_styles" )[0]
            new_lines.append( f"{indent}if getattr(parsed_args, 'style', None):" )
            new_lines.append( f"{indent}    target_styles = [parsed_args.style]" )
            new_lines.append( f"{indent}else:" )
            new_lines.append( f"{indent}    {l}" )
            patched = True
        else:
            new_lines.append(l)

    if patched:
        logger.info( "Patched target_styles successfully." )
    else:
        logger.critical( "target_styles assignment not found in build.py." )

    with open("build.py", "w", encoding="utf-8", newline="\n") as f:
        f.write( "\n".join(new_lines) )

if __name__ == "__main__":
    logger.info( "Starting Patch..." )
    if len(sys.argv) < 4:
        logger.error( "Invalid number of arguments" )
        sys.exit(1)

    else:
        extra_escape = sys.argv[1].split(",") if sys.argv[1] else []
        pill_keywords = sys.argv[2].split(",") if sys.argv[2] else []
        disable_alt_pill = sys.argv[3] == "1"

        patch_files = [
            "source/features/regular.fea",
            "source/features/italic.fea",
            "source/features/regular_cn.fea",
            "source/features/italic_cn.fea",
        ]

        for f in patch_files:
            if os.path.exists(f):
                patch_fea( f, extra_escape, pill_keywords, disable_alt_pill )

        if os.path.exists("build.py"):
            patch_build()

        logger.info( "Finished patching." )
