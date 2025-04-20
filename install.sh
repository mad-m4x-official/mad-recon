#!/bin/bash

# Colors
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

# Banner
echo -e "${GREEN}"
echo "███╗   ███╗ █████╗ ██████╗     ██████╗ ███████╗ ██████╗ ██████╗  ██████╗ ███╗   ██╗"
echo "████╗ ████║██╔══██╗██╔══██╗    ██╔══██╗██╔════╝██╔════╝ ██╔══██╗██╔═══██╗████╗  ██║"
echo "██╔████╔██║███████║██████╔╝    ██████╔╝█████╗  ██║  ███╗██████╔╝██║   ██║██╔██╗ ██║"
echo "██║╚██╔╝██║██╔══██║██╔═══╝     ██╔═══╝ ██╔══╝  ██║   ██║██╔═══╝ ██║   ██║██║╚██╗██║"
echo "██║ ╚═╝ ██║██║  ██║██║         ██║     ███████╗╚██████╔╝██║     ╚██████╔╝██║ ╚████║"
echo "╚═╝     ╚═╝╚═╝  ╚═╝╚═╝         ╚═╝     ╚══════╝ ╚═════╝ ╚═╝      ╚═════╝ ╚═╝  ╚═══╝"
echo -e "${NC}"
echo -e "${YELLOW}Installing mad-recon tools...${NC}"

# Create Go bin path if needed
mkdir -p "$(go env GOPATH)/bin"

# Helper: Install Go Tool
install_go_tool() {
  TOOL=$1
  REPO=$2
  VERSION_CMD=$3
  LATEST_CMD="go install -v $REPO@latest"

  echo -e "\n${YELLOW}[*] Checking $TOOL...${NC}"
  if command -v "$TOOL" >/dev/null 2>&1; then
    CURRENT_VERSION=$($VERSION_CMD 2>/dev/null | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n1)
    echo -e "${GREEN}[✔] $TOOL already installed (v$CURRENT_VERSION)${NC}"
  else
    echo -e "${YELLOW}[~] $TOOL not found. Installing...${NC}"
    if ! $LATEST_CMD; then
      echo -e "${RED}[!] Error installing $TOOL — cleaning Go mod cache and retrying...${NC}"
      go clean -modcache
      $LATEST_CMD || echo -e "${RED}[X] Failed to install $TOOL after retrying.${NC}"
    fi
  fi
}

# Install essential recon tools
install_go_tool "subfinder" "github.com/projectdiscovery/subfinder/v2/cmd/subfinder" "subfinder -version"
install_go_tool "httpx" "github.com/projectdiscovery/httpx/cmd/httpx" "httpx -version"
install_go_tool "naabu" "github.com/projectdiscovery/naabu/v2/cmd/naabu" "naabu -version"
install_go_tool "nuclei" "github.com/projectdiscovery/nuclei/v3/cmd/nuclei" "nuclei -version"
install_go_tool "assetfinder" "github.com/tomnomnom/assetfinder" "assetfinder -h"
install_go_tool "amass" "github.com/owasp-amass/amass/v4/...@master" "amass -version"

# Auto-disable buggy subfinder sources
CONFIG="$HOME/.config/subfinder/provider-config.yaml"
mkdir -p "$(dirname "$CONFIG")"
if [ ! -f "$CONFIG" ]; then
  echo -e "${YELLOW}[~] Creating subfinder provider config...${NC}"
  echo "sources:" > "$CONFIG"
fi

if ! grep -q "digitorus:" "$CONFIG"; then
  echo -e "${YELLOW}[~] Disabling buggy subfinder source: digitorus${NC}"
  echo -e "\ndigitorus:\n  - disabled: true" >> "$CONFIG"
else
  echo -e "${GREEN}[✔] digitorus already disabled${NC}"
fi

# Done
echo -e "\n${GREEN}[✓] mad-recon tools installation complete!${NC}"
