{ pkgs ? import <nixpkgs> { } }:

let
  hooks = pkgs.writeTextFile {
    name = "pre-push";
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      echo "Running pre-push checks..."

      # Clean and build the project
      make clean || true
      if ! make; then
          echo "❌ Build failed"
          exit 1
      fi

      echo "✅ Build passed"
      exit 0
    '';
    executable = true;
  };

  preCommitConfig = pkgs.writeTextFile {
    name = "pre-commit-config.yaml";
    text = ''
      repos:
      - repo: local
        hooks:
          - id: clang-format
            name: clang-format
            entry: clang-format -i
            language: system
            files: \.(c|h)$
            types: [file]
          - id: nixpkgs-fmt
            name: nixpkgs-fmt
            entry: nixpkgs-fmt
            language: system
            files: \.nix$
            types: [file]
    '';
  };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    # Build tools
    gcc
    gnumake
    gdb
    valgrind

    # Formatters and linters
    nixpkgs-fmt
    clang-tools
    pre-commit
    statix
    deadnix
    nodePackages.prettier

    # Additional tools
    cppcheck # Static analysis for C
    gcovr # Code coverage
    cmocka # Unit testing framework
  ];

  shellHook = ''
    echo "Entering development shell..."
  '';

  # Environment variables for development
  CFLAGS = "-Wall -Wextra -g -O2";
  LDFLAGS = "-lcmocka";
}
