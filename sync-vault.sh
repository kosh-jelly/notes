#!/bin/bash
# Sync Obsidian vault to Quartz content folder
# Only syncs files with 'publish: true' in frontmatter

VAULT_PATH="$HOME/Library/CloudStorage/Dropbox/JoshObsidian"
QUARTZ_CONTENT="$HOME/Projects/quartz-site/content"

# Clear existing content (except index.md if it exists)
rm -rf "$QUARTZ_CONTENT"/*

# Find and copy files with publish: true
echo "Syncing published notes from Obsidian vault..."

count=0
find "$VAULT_PATH" -name "*.md" -type f | while read -r file; do
    # Check if file has 'publish: true' in frontmatter
    if head -50 "$file" | grep -q "^publish:[[:space:]]*true"; then
        # Get relative path from vault
        rel_path="${file#$VAULT_PATH/}"
        dest="$QUARTZ_CONTENT/$rel_path"

        # Create directory structure
        mkdir -p "$(dirname "$dest")"

        # Copy file
        cp "$file" "$dest"
        echo "  + $rel_path"
        ((count++))
    fi
done

# Also copy any referenced images/attachments from published content
echo ""
echo "Syncing attachments..."

find "$QUARTZ_CONTENT" -name "*.md" -type f 2>/dev/null | while read -r mdfile; do
    # Extract wikilink image references like ![[image.png]]
    grep -oE '\!\[\[[^]]+\]\]' "$mdfile" 2>/dev/null | sed 's/!\[\[//;s/\]\]//' | while read -r img_name; do
        if [ -n "$img_name" ]; then
            # Find and copy the image if it exists in vault
            img_file=$(find "$VAULT_PATH" -name "$(basename "$img_name")" -type f 2>/dev/null | head -1)
            if [ -n "$img_file" ] && [ -f "$img_file" ]; then
                dest_img="$QUARTZ_CONTENT/$(basename "$img_file")"
                if [ ! -f "$dest_img" ]; then
                    cp "$img_file" "$dest_img"
                    echo "  + $(basename "$img_file")"
                fi
            fi
        fi
    done
done

echo ""
echo "Sync complete!"
echo "Run 'npx quartz build' to build the site, or 'npx quartz build --serve' to preview."
