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

## Resetting an existing Mac

To converge an already-configured Mac back to the desired state (update all packages, fix missing tools, reset `.zshrc`):

```sh
bash src/reset.sh
```

The reset script will:
1. Run `brew update`, `brew upgrade`, and `brew cleanup` (full system upgrade)
2. Install any declared packages/casks that are missing
3. Skip SSH key generation if any `~/.ssh/id_*` key already exists
4. Overwrite `~/.zshrc` with the template and append folder aliases from `src/aliases.sh`
5. Ensure alias target folders exist (e.g. `~/Documents/Projects`)
6. Reapply macOS defaults (dock, key repeat, Finder hidden files, screenshot shadow)
7. Prompt for git name/email only if not already configured
