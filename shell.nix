# shell.nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Core build tools
    gcc
    gnumake
    glibc
    
    # Development tools
    gdb
    
    # Utilities
    dos2unix
  ];

  shellHook = ''
    # Convert line endings (WSL requirement)
    find . -type f -name "Makefile" -exec dos2unix {} + 2>/dev/null || true
    find . -type f -name "*.c" -exec dos2unix {} + 2>/dev/null || true
    find . -type f -name "*.h" -exec dos2unix {} + 2>/dev/null || true
    
    # Set up basic environment
    export LANG=C.UTF-8
    export LC_ALL=C.UTF-8
    
    echo "Jeopardy Game Development Environment Ready"
    echo "----------------------------------------"
    echo "Available commands:"
    echo "  make clean     - Clean build artifacts"
    echo "  make all       - Build the game"
    echo "  ./jeopardy     - Run the game"
  '';
}