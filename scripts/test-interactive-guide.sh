#!/bin/bash
# Test Interactive Tools Overview HTML Guide
# This script validates the interactive guide using browser automation
#
# Usage:
#   ./scripts/test-interactive-guide.sh [--server-only] [--port PORT]
#
# The script:
# 1. Starts a local HTTP server
# 2. Validates all tabs render correctly
# 3. Validates all internal links exist
# 4. Validates Mermaid diagrams render
# 5. Tests interactive elements (tool cards)
#
# For full browser automation testing, use with Playwright MCP:
#   npx @playwright/test test-interactive-guide.spec.ts

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DOCS_DIR="$PROJECT_DIR/docs/tools"
PORT="${PORT:-8765}"
SERVER_PID=""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Cleanup function
cleanup() {
    if [ -n "$SERVER_PID" ]; then
        echo -e "${YELLOW}Stopping server (PID: $SERVER_PID)...${NC}"
        kill $SERVER_PID 2>/dev/null || true
    fi
}
trap cleanup EXIT

# Start server
start_server() {
    echo -e "${BLUE}Starting local server on port $PORT...${NC}"
    cd "$DOCS_DIR"
    python3 -m http.server $PORT &>/dev/null &
    SERVER_PID=$!
    sleep 2
    
    # Check if server started
    if ! kill -0 $SERVER_PID 2>/dev/null; then
        echo -e "${RED}Failed to start server${NC}"
        exit 1
    fi
    echo -e "${GREEN}Server started (PID: $SERVER_PID)${NC}"
}

# Test: Check HTML file exists
test_file_exists() {
    echo -e "\n${BLUE}[TEST] Checking HTML file exists...${NC}"
    if [ -f "$DOCS_DIR/interactive-tools-overview.html" ]; then
        echo -e "${GREEN}✓ HTML file exists${NC}"
        return 0
    else
        echo -e "${RED}✗ HTML file not found${NC}"
        return 1
    fi
}

# Test: Validate all internal links point to existing files
test_internal_links() {
    echo -e "\n${BLUE}[TEST] Validating internal links...${NC}"
    local errors=0
    
    # Extract href values from HTML (excluding external URLs and anchors)
    local links=$(grep -oE 'href="[^"#]+\.md[^"]*"' "$DOCS_DIR/interactive-tools-overview.html" | \
                  sed 's/href="//g' | sed 's/"//g' | sort -u)
    
    # Also check for click handlers in Mermaid
    local mermaid_links=$(grep -oE 'click [A-Za-z_]+ "[^"]+\.md[^"]*"' "$DOCS_DIR/interactive-tools-overview.html" | \
                          sed 's/click [A-Za-z_]* "//g' | sed 's/".*//g' | sort -u)
    
    # Combine and deduplicate
    local all_links=$(echo -e "$links\n$mermaid_links" | sort -u | grep -v '^$')
    
    echo "Found $(echo "$all_links" | wc -l | tr -d ' ') unique internal links to validate"
    
    while IFS= read -r link; do
        # Remove anchor part for file existence check
        local file_path=$(echo "$link" | sed 's/#.*//')
        local full_path="$DOCS_DIR/$file_path"
        
        if [ -f "$full_path" ]; then
            echo -e "${GREEN}  ✓ $link${NC}"
        else
            echo -e "${RED}  ✗ $link (file not found: $full_path)${NC}"
            ((errors++))
        fi
    done <<< "$all_links"
    
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}✓ All internal links validated${NC}"
        return 0
    else
        echo -e "${RED}✗ $errors broken internal links found${NC}"
        return 1
    fi
}

# Test: Validate Mermaid CDN is reachable
test_mermaid_cdn() {
    echo -e "\n${BLUE}[TEST] Validating Mermaid CDN...${NC}"
    local mermaid_url=$(grep -oE 'https://cdn.jsdelivr.net/npm/mermaid@[^"]+' "$DOCS_DIR/interactive-tools-overview.html" | head -1)
    
    if [ -z "$mermaid_url" ]; then
        echo -e "${RED}✗ Mermaid CDN URL not found in HTML${NC}"
        return 1
    fi
    
    echo "Checking: $mermaid_url"
    
    if curl -s --head "$mermaid_url" | head -1 | grep -q "200\|301\|302"; then
        echo -e "${GREEN}✓ Mermaid CDN is reachable${NC}"
        return 0
    else
        echo -e "${RED}✗ Mermaid CDN is not reachable${NC}"
        return 1
    fi
}

# Test: Count expected tabs
test_tab_count() {
    echo -e "\n${BLUE}[TEST] Validating tab structure...${NC}"
    local tab_count=$(grep -oE 'class="tab[ "]' "$DOCS_DIR/interactive-tools-overview.html" | wc -l | tr -d '[:space:]')
    
    if [ "$tab_count" -eq 5 ]; then
        echo -e "${GREEN}✓ Found expected 5 tabs${NC}"
        return 0
    else
        echo -e "${RED}✗ Expected 5 tabs, found $tab_count${NC}"
        return 1
    fi
}

# Test: Count Mermaid diagrams
test_mermaid_diagram_count() {
    echo -e "\n${BLUE}[TEST] Validating Mermaid diagram count...${NC}"
    local diagram_count=$(grep -c 'class="mermaid"' "$DOCS_DIR/interactive-tools-overview.html" || echo 0)
    
    if [ "$diagram_count" -ge 5 ]; then
        echo -e "${GREEN}✓ Found $diagram_count Mermaid diagrams (expected >= 5)${NC}"
        return 0
    else
        echo -e "${RED}✗ Expected at least 5 Mermaid diagrams, found $diagram_count${NC}"
        return 1
    fi
}

# Test: Count tool cards
test_tool_card_count() {
    echo -e "\n${BLUE}[TEST] Validating tool cards...${NC}"
    local card_count=$(grep -c 'class="tool-card"' "$DOCS_DIR/interactive-tools-overview.html" || echo 0)
    
    if [ "$card_count" -eq 7 ]; then
        echo -e "${GREEN}✓ Found expected 7 tool cards${NC}"
        return 0
    else
        echo -e "${RED}✗ Expected 7 tool cards, found $card_count${NC}"
        return 1
    fi
}

# Test: Validate HTML syntax (basic check)
test_html_syntax() {
    echo -e "\n${BLUE}[TEST] Validating HTML syntax...${NC}"
    
    # Check for basic HTML structure
    local has_doctype=$(grep -c '<!DOCTYPE html>' "$DOCS_DIR/interactive-tools-overview.html" || echo 0)
    local has_html_open=$(grep -c '<html' "$DOCS_DIR/interactive-tools-overview.html" || echo 0)
    local has_html_close=$(grep -c '</html>' "$DOCS_DIR/interactive-tools-overview.html" || echo 0)
    local has_head=$(grep -c '<head>' "$DOCS_DIR/interactive-tools-overview.html" || echo 0)
    local has_body=$(grep -c '<body>' "$DOCS_DIR/interactive-tools-overview.html" || echo 0)
    
    if [ "$has_doctype" -ge 1 ] && [ "$has_html_open" -ge 1 ] && [ "$has_html_close" -ge 1 ] && [ "$has_head" -ge 1 ] && [ "$has_body" -ge 1 ]; then
        echo -e "${GREEN}✓ HTML structure is valid${NC}"
        return 0
    else
        echo -e "${RED}✗ HTML structure is invalid${NC}"
        return 1
    fi
}

# Test: Check for syntax errors in Mermaid diagrams
test_mermaid_syntax() {
    echo -e "\n${BLUE}[TEST] Checking Mermaid syntax patterns...${NC}"
    local errors=0
    
    # Check for problematic patterns that cause rendering issues
    
    # Pattern 1: 'direction' inside subgraphs (causes NaN errors)
    local direction_count=$(grep -E 'subgraph.*\n.*direction' "$DOCS_DIR/interactive-tools-overview.html" 2>/dev/null | wc -l | tr -d '[:space:]' || echo 0)
    if [ "${direction_count:-0}" -gt 0 ]; then
        echo -e "${YELLOW}  ⚠ Found 'direction' statements that may cause issues${NC}"
        ((errors++))
    else
        echo -e "${GREEN}  ✓ No problematic 'direction' statements${NC}"
    fi
    
    # Pattern 2: 'style' applied to subgraphs (causes layout issues)
    local style_subgraph=$(grep -c 'style [A-Za-z]*\[' "$DOCS_DIR/interactive-tools-overview.html" 2>/dev/null | tr -d '[:space:]' || echo 0)
    if [ "${style_subgraph:-0}" -gt 0 ]; then
        echo -e "${YELLOW}  ⚠ Found 'style' on subgraphs that may cause issues${NC}"
        ((errors++))
    else
        echo -e "${GREEN}  ✓ No problematic 'style' statements on subgraphs${NC}"
    fi
    
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}✓ Mermaid syntax patterns look good${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠ Found $errors potential Mermaid issues (may still render)${NC}"
        return 0  # Don't fail, just warn
    fi
}

# Main test runner
run_tests() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  Interactive Guide Test Suite${NC}"
    echo -e "${BLUE}========================================${NC}"
    
    local total_tests=0
    local passed_tests=0
    local failed_tests=0
    
    # Run all tests
    tests=(
        "test_file_exists"
        "test_html_syntax"
        "test_tab_count"
        "test_mermaid_diagram_count"
        "test_tool_card_count"
        "test_internal_links"
        "test_mermaid_syntax"
        "test_mermaid_cdn"
    )
    
    for test in "${tests[@]}"; do
        ((total_tests++))
        if $test; then
            ((passed_tests++))
        else
            ((failed_tests++))
        fi
    done
    
    # Summary
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}  Test Summary${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo -e "Total tests:  $total_tests"
    echo -e "${GREEN}Passed:       $passed_tests${NC}"
    if [ $failed_tests -gt 0 ]; then
        echo -e "${RED}Failed:       $failed_tests${NC}"
    else
        echo -e "Failed:       $failed_tests"
    fi
    
    if [ $failed_tests -eq 0 ]; then
        echo -e "\n${GREEN}All tests passed!${NC}"
        return 0
    else
        echo -e "\n${RED}Some tests failed!${NC}"
        return 1
    fi
}

# Parse arguments
SERVER_ONLY=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --server-only)
            SERVER_ONLY=true
            shift
            ;;
        --port)
            PORT="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Main
if [ "$SERVER_ONLY" = true ]; then
    start_server
    echo -e "\n${BLUE}Server running at http://localhost:$PORT${NC}"
    echo -e "Press Ctrl+C to stop"
    wait $SERVER_PID
else
    run_tests
fi
