#!/bin/bash
# sanitize-content.sh
# Sanitize sensitive information from markdown files before publishing

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

CONTENT_DIR="content"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${YELLOW}Sanitizing content in $CONTENT_DIR...${NC}"

# Check if content directory exists
if [ ! -d "$SCRIPT_DIR/$CONTENT_DIR" ]; then
    echo -e "${RED}✗ Error: Content directory not found: $SCRIPT_DIR/$CONTENT_DIR${NC}"
    exit 1
fi

# Counter for files processed
FILE_COUNT=0

# Find all markdown files and process them
find "$SCRIPT_DIR/$CONTENT_DIR" -name "*.md" -type f | while read -r file; do
    # Skip if file doesn't exist (edge case)
    [ ! -f "$file" ] && continue

    FILE_COUNT=$((FILE_COUNT + 1))

    # IP Addresses (192.168.1.x)
    sed -i 's/192\.168\.1\.[0-9]\+/192.168.1.XXX/g' "$file"

    # IP Addresses (other private ranges - optional, adjust as needed)
    sed -i 's/10\.[0-9]\+\.[0-9]\+\.[0-9]\+/10.X.X.X/g' "$file"
    sed -i 's/172\.1[6-9]\.[0-9]\+\.[0-9]\+/172.X.X.X/g' "$file"
    sed -i 's/172\.2[0-9]\.[0-9]\+\.[0-9]\+/172.X.X.X/g' "$file"
    sed -i 's/172\.3[0-1]\.[0-9]\+\.[0-9]\+/172.X.X.X/g' "$file"

    # Credentials - common patterns
    sed -i 's/password:\s*\S\+/password: [REDACTED]/gi' "$file"
    sed -i 's/passwd:\s*\S\+/passwd: [REDACTED]/gi' "$file"
    sed -i 's/api[_-]\?key:\s*\S\+/api_key: [REDACTED]/gi' "$file"
    sed -i 's/token:\s*\S\+/token: [REDACTED]/gi' "$file"
    sed -i 's/secret:\s*\S\+/secret: [REDACTED]/gi' "$file"
    sed -i 's/bearer\s\+[A-Za-z0-9_-]\+/bearer [REDACTED]/gi' "$file"

    # Personal email (adjust domain as needed)
    # Example: james@hathcock.com -> admin@example.com
    sed -i 's/[a-zA-Z0-9._%+-]\+@hathcock\.[a-zA-Z]\+/admin@example.com/g' "$file"

    # MAC addresses
    sed -i 's/\([0-9a-fA-F]\{2\}:\)\{5\}[0-9a-fA-F]\{2\}/XX:XX:XX:XX:XX:XX/g' "$file"

    # Internal hostnames - .local domains
    sed -i 's/\([a-zA-Z0-9-]\+\)\.local/\1.internal/g' "$file"

    # Internal hostnames - .home domains
    sed -i 's/\([a-zA-Z0-9-]\+\)\.home/\1.internal/g' "$file"

    # Specific internal hostnames (add your own)
    # sed -i 's/nas01/nas/g' "$file"
    # sed -i 's/pve01/proxmox/g' "$file"

    # Port numbers in URLs with private IPs (already sanitized above)
    # This is redundant but keeps the pattern clear
    sed -i 's/192\.168\.1\.[0-9]\+:[0-9]\+/192.168.1.XXX:PORT/g' "$file"

    # Common credential variables in code blocks
    sed -i 's/ADMIN_PASSWORD=.*/ADMIN_PASSWORD=[REDACTED]/g' "$file"
    sed -i 's/DB_PASSWORD=.*/DB_PASSWORD=[REDACTED]/g' "$file"
    sed -i 's/API_KEY=.*/API_KEY=[REDACTED]/g' "$file"

done

echo -e "${GREEN}✓ Sanitization complete${NC}"
echo ""
echo "Security verification commands:"
echo "  grep -r '192\.168\.1\.[0-9]' content/  # Check for unsanitized IPs"
echo "  grep -ri 'password:' content/          # Check for credentials"
echo "  grep -ri 'hathcock' content/           # Check for personal info"
