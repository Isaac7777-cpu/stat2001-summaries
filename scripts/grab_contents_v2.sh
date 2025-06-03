#!/bin/bash

echo "sidebar:"
echo "  style: \"docked\""
echo "  background: dark"
echo "  collapse-level: 1"
echo "  contents:"

# Loop through each chapter folder
for chapter in $(find contents -mindepth 1 -maxdepth 1 -type d | sort); do
  chapter_name=$(basename "$chapter")
  index_path="$chapter/index.qmd"

  # Find all .qmd files (excluding index.qmd)
  other_qmds=$(find "$chapter" -maxdepth 1 -name '*.qmd' ! -name 'index.qmd' | sort)

  if [[ -f "$index_path" && -z "$other_qmds" ]]; then
    # Only index.qmd exists → use text + href
    echo "    - text: \"$chapter_name\""
    echo "      href: $index_path"
  else
    # index.qmd + others → use section + href + contents
    echo "    - section: \"$chapter_name\""
    if [[ -f "$index_path" ]]; then
      echo "      href: $index_path"
    fi
    if [[ -n "$other_qmds" ]]; then
      echo "      contents:"
      while IFS= read -r file; do
        echo "        - $file"
      done <<< "$other_qmds"
    fi
  fi
done