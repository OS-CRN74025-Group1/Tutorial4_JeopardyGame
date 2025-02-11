# Jeopardy Game

## Setting up the Development Environment

A C-based implementation of the Jeopardy game for Operating Systems course.

To set up the development environment for the Tutorial4_JeopardyGame project, you have two options using Nix:
1. Using `nix develop` (recommended, uses flakes)
2. Using `nix-shell` (legacy approach)

Both methods will ensure that all the necessary dependencies and tools are available.

### Installing Nix

First, you need to install Nix. Nix can be installed in two modes: multi-user and single-user.

-   **Multi-user mode**: This mode is suitable for systems with multiple users. It requires root privileges to install and allows all users on the system to use Nix.
-   **Single-user mode**: This mode is suitable for systems with a single user or for users who do not have root privileges. It installs Nix in the user's home directory.

#### Multi-user Installation

For **_Linux_** (including **_WSL_**) and **_macOS_**:

```bash
sh <(curl -L https://nixos.org/nix/install)
```

Single-user Installation

For **_NixOS-WSL_**:

```powershell
# Download latest release
wsl --import NixOS $env:USERPROFILE\NixOS\ nixos-wsl.tar.gz --version 2

# Get a shell in NixOS environment
wsl -d NixOS

# Update channels (required after install)
sudo nix-channel --update

# Optional: Make NixOS default distribution
wsl -s NixOS
```

```cmd
# Alternative for Command Prompt
wsl --import NixOS %USERPROFILE%\NixOS\ nixos-wsl.tar.gz --version 2
```

Note: NixOS-WSL requires Windows Store version of WSL 2 (Windows 10 or 11). Download the latest release from [NixOS-WSL releases](https://github.com/nix-community/NixOS-WSL/releases/latest).

After installation, you can verify that Nix is installed by running:

```bash
nix --version
```

### Development Environment Options

#### Option 1: Using `nix develop` (Recommended)

This is the modern approach using Nix flakes. It provides a more reproducible environment and better dependency management.

1. Enable flakes in your Nix configuration:
   ```bash
   # Add this to ~/.config/nix/nix.conf or /etc/nix/nix.conf
   experimental-features = nix-command flakes
   ```

2. Enter the development environment:
   ```bash
   # For temporary quick development session, use:
   export NIX_CONFIG="experimental-features = nix-command flakes" && nix develop
   ```

This will provide you with:
- Build tools: gcc, make, gdb, valgrind
- Formatters and linters: clang-tools, alejandra, statix, deadnix, prettier
- Testing tools: cppcheck, gcovr, cmocka
- Pre-configured git hooks for code formatting

#### Option 2: Using `nix-shell`

This is the legacy approach that uses the traditional Nix package management.

Enter the development environment by running:
```bash
nix-shell
```

This provides the same tools as `nix develop` but uses the older Nix infrastructure.

### Building the Project

Once you're in either development environment, you can build the project using:

```bash
make
```

### Development Tools Available

Both environments provide the following tools:

🛠️ **Build Tools**:
  - `make` - Build the project
  - `gcc` - C compiler
  - `gdb` - Debugger
  - `valgrind` - Memory checker

🔍 **Testing Tools**:
  - `cppcheck` - Static analysis
  - `gcovr` - Code coverage
  - `cmocka` - Unit testing

✨ **Formatters and Linters**:
  - `clang-format` - C code formatter
  - `alejandra` - Nix formatter (flakes only)
  - `statix` - Nix linter
  - `deadnix` - Find dead Nix code
  - `prettier` - Format markdown/yaml/json

🔄 **Git Hooks**:
  - `pre-commit run` - Run hooks on staged files
  - `pre-commit run -a` - Run hooks on all files
