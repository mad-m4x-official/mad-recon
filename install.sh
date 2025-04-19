#!/bin/bash

set -e

GREEN="\033[1;32m"
RED="\033[1;31m"
RESET="\033[0m"

TOOLS=(
  "github.com/projectdiscovery/subfinder/v2/cmd/subfinder"
  "github.com/projectdiscovery/httpx/cmd/httpx"
  "github.com/projectdiscovery/naabu/v2/cmd/naabu"
  "github.com/projectdiscovery/nuclei/v3/cmd/nuclei"
  "github.com/projectdiscovery/dnsx/cmd/dnsx"
  "github.com/projectdiscovery/katana/cmd/katana"
  "github.com/projectdiscovery/notify/cmd/notify"
  "github.com/projectdiscovery/interactsh/cmd/interactsh-client"
  "github.com/owasp-amass/amass/v4/..."
  "github.com/lc/gau/v2/cmd/gau"
  "github.com/tomnomnom/waybackurls"
  "github.com/tomnomnom/assetfinder"
  "github.com/tomnomnom/httprobe"
  "github.com/hakluke/hakrevdns"
  "github.com/hakluke/hakrawler"
  "github.com/hakluke/hakcheckurl"
  "github.com/dwisiswant0/crlfuzz/cmd/crlfuzz"
  "github.com/ffuf/ffuf"
  "github.com/ProjectAnte/dnsgen"
  "github.com/devanshbatham/openredirex"
)

install_tool() {
  TOOL=$1
  NAME=$(basename $TOOL)

  if command -v $NAME >/dev/null 2>&1; then
    echo -e "${GREEN}[+] $NAME already installed.${RESET}"
  else
    echo -e "${GREEN}[+] Installing $NAME...${RESET}"
    if ! go install "$TOOL@latest"; then
      echo -e "${RED}[!] $NAME install failed. Trying to fix...${RESET}"
      TOOL_PATH=$(go env GOPATH)/pkg/mod/$(echo "$TOOL" | sed 's|github.com/||')
      sudo chown -R $USER:$USER "$TOOL_PATH" 2>/dev/null || true
      rm -rf "$TOOL_PATH" 2>/dev/null || true
      go install "$TOOL@latest"
    fi
  fi
}

echo -e "${GREEN}[*] Starting Mad Recon Installation...${RESET}"
sleep 1

# Update & install dependencies
sudo apt update -y && sudo apt install -y git curl wget unzip jq build-essential

# Install Go if not present
if ! command -v go >/dev/null 2>&1; then
  echo -e "${GREEN}[+] Installing Golang...${RESET}"
  wget https://go.dev/dl/go1.22.2.linux-amd64.tar.gz
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz
  echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bashrc
  source ~/.bashrc
  export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
  rm go1.22.2.linux-amd64.tar.gz
fi

# Create ~/go/bin if not exists
mkdir -p ~/go/bin

# Install tools
for TOOL in "${TOOLS[@]}"; do
  install_tool "$TOOL"
done

echo -e "${GREEN} All tools installed successfully!${RESET}"
