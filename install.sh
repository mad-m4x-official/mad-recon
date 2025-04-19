#!/bin/bash

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

REPO_URL="https://github.com/mad-m4x-official/mad-recon"
TOOLS_DIR="$HOME/.mad-recon-tools"

print_status() {
    echo -e "${GREEN}[+] $1${NC}"
}

print_error() {
    echo -e "${RED}[!] $1${NC}"
}

install_requirements() {
    print_status "Updating package list and installing required packages..."
    sudo apt update && sudo apt install -y git curl wget unzip jq build-essential
}

install_go() {
    if ! command -v go &>/dev/null; then
        print_status "Installing Golang..."
        wget https://go.dev/dl/go1.22.2.linux-amd64.tar.gz
        sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
        echo 'export GOPATH=$HOME/go' >> ~/.bashrc
        source ~/.bashrc
        rm go1.22.2.linux-amd64.tar.gz
    else
        print_status "Golang already installed."
    fi
}

add_to_path() {
    export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
}

install_tool() {
    TOOL=$1
    CMD=$2
    URL=$3

    if ! command -v $CMD &>/dev/null; then
        print_status "Installing $TOOL..."
        go install -v $URL@latest || {
            print_error "$TOOL install failed. Trying to fix..."
            go clean -modcache
            rm -rf ~/go/pkg/mod/github.com/!mzack9999/gcache || true
            go install -v $URL@latest || print_error "$TOOL failed again. Skipping."
        }
    else
        print_status "$TOOL already installed."
    fi
}

main() {
    echo -e "${GREEN}[*] Starting Mad Recon Installation...${NC}"
    install_requirements
    install_go
    add_to_path

    install_tool "subfinder" "subfinder" "github.com/projectdiscovery/subfinder/v2/cmd/subfinder"
    install_tool "httpx" "httpx" "github.com/projectdiscovery/httpx/cmd/httpx"
    install_tool "naabu" "naabu" "github.com/projectdiscovery/naabu/v2/cmd/naabu"
    install_tool "nuclei" "nuclei" "github.com/projectdiscovery/nuclei/v3/cmd/nuclei"
    install_tool "dnsx" "dnsx" "github.com/projectdiscovery/dnsx/cmd/dnsx"
    install_tool "katana" "katana" "github.com/projectdiscovery/katana/cmd/katana"
    install_tool "shuffledns" "shuffledns" "github.com/projectdiscovery/shuffledns/cmd/shuffledns"
    install_tool "gau" "gau" "github.com/lc/gau/v2/cmd/gau"
    install_tool "waybackurls" "waybackurls" "github.com/tomnomnom/waybackurls"
    install_tool "gf" "gf" "github.com/tomnomnom/gf"
    install_tool "qsreplace" "qsreplace" "github.com/tomnomnom/qsreplace"
    install_tool "anew" "anew" "github.com/tomnomnom/anew"
    install_tool "uro" "uro" "github.com/s0md3v/uro"

    print_status "Installation completed. Run your tools from anywhere."
}

main
