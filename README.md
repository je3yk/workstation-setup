# workstation-setup

Script that configures all necessary tools on a new Mac workstation.

## Running on a fresh Mac

macOS ships with `curl` and `git` (invoking `git` will prompt you to install Xcode Command Line Tools if needed — accept it). Open **Terminal** and run:

**Step 1 — install Xcode Command Line Tools** (skip if already done):
```sh
xcode-select --install
```

**Step 2 — clone and run the script:**
```sh
curl -fsSL https://github.com/je3yk/workstation-setup/archive/refs/heads/main.tar.gz | tar -xz && cd workstation-setup-main && bash src/script.sh
```

Or if you prefer cloning with git:
```sh
git clone https://github.com/je3yk/workstation-setup.git && cd workstation-setup && bash src/script.sh
```

The script will:
1. Install Homebrew and all tools/apps
2. Set up Oh My ZSH + oh-my-posh (atomic theme)
3. Copy a `.zshrc` template to `~/.zshrc`
4. Apply sensible macOS defaults
5. Prompt for your git name/email
6. Generate an SSH key and print the public key to add to GitHub

After it finishes, restart Terminal.
