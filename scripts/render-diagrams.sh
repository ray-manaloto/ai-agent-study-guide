#!/bin/bash
# Render Mermaid diagrams to PNG

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DOCS_DIR="$PROJECT_DIR/docs"

echo "Rendering Mermaid diagrams..."

# Check for mermaid-cli
if ! command -v mmdc &> /dev/null; then
    echo "Installing mermaid-cli..."
    npm install -g @mermaid-js/mermaid-cli
fi

# Render architecture diagram
if [ -f "$DOCS_DIR/architecture-diagram.md" ]; then
    echo "Rendering architecture-diagram.md..."
    mmdc -i "$DOCS_DIR/architecture-diagram.md" -o "$DOCS_DIR/architecture-diagram.png" -t dark
    echo "Created: $DOCS_DIR/architecture-diagram.png"
fi

echo "Done!"
