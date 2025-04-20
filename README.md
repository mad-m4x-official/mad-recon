# 🕵️‍♂️ Mad Recon

**Mad Recon** is a one-click, auto-fixing, all-in-one reconnaissance toolkit built for bug bounty hunters and security researchers. This tool automates the installation and update of all essential recon tools using a simple shell script.

## 🚀 Features

- Install or update top recon tools with a single command
- Detects already-installed tools to avoid redundancy
- Automatically fixes common errors
- Supports Kali Linux and other Debian-based systems
- Ideal for CTF, Bug Bounty, and Pentesting setups

---

## 🔧 Tools Included

| Category       | Tools                                                                 |
|----------------|-----------------------------------------------------------------------|
| Subdomain Enum | `subfinder`, `assetfinder`, `amass`, `crtsh`, `findomain`, `sublist3r` |
| Probing        | `httpx`, `httprobe`, `httptoolkit`                                   |
| Port Scanning  | `naabu`, `nmap`, `masscan`                                            |
| Vulnerability  | `nuclei`, `gf`, `dalfox`, `qsreplace`                                |
| Fuzzing        | `ffuf`, `wfuzz`, `dirsearch`, `feroxbuster`                          |
| Wordlists      | `SecLists`, `dnsgen`                                                  |
| Cloud          | `cloud_enum`, `s3scanner`, `bucket_finder`                           |
| JS Analysis    | `linkfinder`, `jsfinder`, `secretfinder`, `xnLinkFinder`             |
| Others         | `waybackurls`, `gau`, `kxss`, `uro`, `unfurl`, `notify`              |

---

## 📥 Installation

Just run this single command to install Mad Recon and all tools:

```bash
bash <(curl -s https://raw.githubusercontent.com/mad-m4x-official/mad-recon/main/install.sh)

git clone https://github.com/mad-m4x-official/mad-recon.git
cd mad-recon
chmod +x install.sh
./install.sh



