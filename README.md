# Jeopardy Game

A C implementation of the Jeopardy game for Operating Systems course.

## Project Structure

```
.
├── src/                    # Source code
│   ├── app/               # Application source files
│   │   └── jeopardy.c     # Main program
│   ├── include/           # Header files
│   │   ├── jeopardy.h
│   │   ├── players.h
│   │   └── questions.h
│   └── lib/              # Library source files
│       ├── players.c
│       └── questions.c
├── build/                # Build artifacts
├── docs/                 # Documentation
├── tools/                # Development tools and scripts
├── Makefile             # Build configuration
├── flake.nix            # Nix development environment
└── shell.nix            # Legacy Nix shell configuration
```

## Development Environment

This project uses Nix for reproducible development environments. To get started:

<details>
<summary>📦 Installing Nix with Determinate Systems Installer (Recommended)</summary>

The Determinate Nix Installer provides a smoother experience with automatic flakes support and easy uninstallation:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Alternative installation methods:

1. Download and verify:
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix > nix-installer.sh
   chmod +x nix-installer.sh
   ./nix-installer.sh install
   ```

2. Legacy multi-user installation:
   ```bash
   sh <(curl -L https://nixos.org/nix/install)
   ```

> **Note**: For WSL2, download the latest release from [NixOS-WSL releases](https://github.com/nix-community/NixOS-WSL/releases/latest)
3. For WSL2 users:
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

   Alternative for Command Prompt:
   ```cmd
   wsl --import NixOS %USERPROFILE%\NixOS\ nixos-wsl.tar.gz --version 2
   ```

Verify installation:
```bash
nix --version
```
</details>

---


1. With Nix Flakes (recommended):
   ```bash
   nix develop
   ```

2. Without Flakes (legacy):
   ```bash
   nix-shell
   ```

## Building

```bash
# Build the project
make

# Build and run
make run

# Build with debug symbols
make debug

# Clean build artifacts
make clean
```

## Project Organization

- `src/app/`: Contains the main application code
- `src/include/`: Header files defining the public API
- `src/lib/`: Implementation of the game's core functionality
- `build/`: Compiled objects and executable
- `docs/`: Project documentation
- `tools/`: Development utilities and scripts

## Development Workflow

1. Source code changes go in the appropriate subdirectory under `src/`
2. Build artifacts are automatically placed in `build/`
3. Use `make run` for quick testing
4. Use `make debug` for debugging with GDB

## Tools Available

The development environment includes:
- GCC compiler
- GNU Make
- GDB debugger
- Valgrind memory checker
- Clang tools for static analysis
