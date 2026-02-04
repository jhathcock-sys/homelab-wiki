#!/bin/bash
# sync-sanitize.sh
# Sync content from homelab-docs and sanitize before publishing

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Paths
SOURCE_DIR="$HOME/Documents/HomeLab/HomeLab"
TARGET_DIR="$HOME/homelab-wiki/content"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SANITIZE_SCRIPT="$SCRIPT_DIR/sanitize-content.sh"
EXCLUDE_FILE="$SCRIPT_DIR/.publish-exclude"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Homelab Wiki Sync & Sanitize${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}✗ Error: Source directory not found: $SOURCE_DIR${NC}"
    exit 1
fi

# Check if sanitize script exists
if [ ! -f "$SANITIZE_SCRIPT" ]; then
    echo -e "${RED}✗ Error: Sanitization script not found: $SANITIZE_SCRIPT${NC}"
    exit 1
fi

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Step 1: Sync content from homelab-docs
echo -e "${YELLOW}→ Syncing content from homelab-docs...${NC}"

# Build rsync exclude options from .publish-exclude file
EXCLUDE_OPTS=""
if [ -f "$EXCLUDE_FILE" ]; then
    while IFS= read -r pattern; do
        # Skip empty lines and comments
        [[ -z "$pattern" || "$pattern" =~ ^[[:space:]]*# ]] && continue
        EXCLUDE_OPTS="$EXCLUDE_OPTS --exclude=$pattern"
    done < "$EXCLUDE_FILE"
fi

# Rsync command to copy markdown and image files
# Note: Order matters! Excludes must come before includes
rsync -av --delete \
    $EXCLUDE_OPTS \
    --include='*/' \
    --include='*.md' \
    --include='*.png' \
    --include='*.jpg' \
    --include='*.jpeg' \
    --include='*.gif' \
    --include='*.svg' \
    --exclude='*' \
    "$SOURCE_DIR/" "$TARGET_DIR/"

echo -e "${GREEN}✓ Content synced successfully${NC}"
echo ""

# Step 2: Run sanitization
echo -e "${YELLOW}→ Running sanitization script...${NC}"
bash "$SANITIZE_SCRIPT"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✓ Sync and sanitization complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Next steps:"
echo "  1. Review changes: git status"
echo "  2. Check sanitization: grep -r '192.168.1' content/"
echo "  3. Commit and push to deploy"
