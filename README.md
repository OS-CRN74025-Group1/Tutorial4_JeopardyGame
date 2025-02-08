# Tutorial4_JeopardyGame
## Setting up the Development Environment

To set up the development environment for the Tutorial4_JeopardyGame project, you will need to use `nix-shell`. This will ensure that all the necessary dependencies and tools are available.

### Installing Nix

First, you need to install Nix. Nix can be installed in two modes: multi-user and single-user.

- **Multi-user mode**: This mode is suitable for systems with multiple users. It requires root privileges to install and allows all users on the system to use Nix.
- **Single-user mode**: This mode is suitable for systems with a single user or for users who do not have root privileges. It installs Nix in the user's home directory.

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
Once Nix is installed, you can enter the development environment for the Tutorial4_JeopardyGame project by running:

```bash
nix-shell
```
