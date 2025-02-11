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
    # Tool documentation
    echo "🛠️  Available development tools:"
    echo ""
    echo "  🔨 Build tools:"
    echo "    make          - Build the project"
    echo "    gcc          - C compiler"
    echo "    gdb          - Debugger"
    echo "    valgrind     - Memory checker"
    echo ""
    echo "  🔍 Testing tools:"
    echo "    cppcheck     - Static analysis"
    echo "    gcovr        - Code coverage"
    echo "    cmocka       - Unit testing"
    echo ""
    echo "  ✨ Formatters and linters:"
    echo "    clang-format - C code formatter"
    echo "    cppcheck     - C code static analyzer"
    echo "    nixpkgs-fmt  - Nix formatter"
    echo "    prettier     - Format MD/YAML/JSON"
    echo ""
    echo "  🔄 Git hooks:"
    echo "    pre-commit run     - Run hooks on staged files"
    echo "    pre-commit run -a  - Run hooks on all files"
    echo ""
    echo "  🧪 Test commands:"
    echo "    make clean && make && ./jeopardy test"
    echo "    valgrind --leak-check=full ./jeopardy"
    echo "    cppcheck --enable=all ."
    echo ""

    # Setup git hooks if .git directory exists
    if [ -d .git ]; then
      echo "Setting up git hooks..."
      mkdir -p .git/hooks
      cp ${hooks} .git/hooks/pre-push
      cp ${preCommitConfig} .pre-commit-config.yaml
      pre-commit install --install-hooks || true
      echo "Git hooks installed successfully"
    fi
  '';

  # Environment variables for development
  CFLAGS = "-Wall -Wextra -g -O2";
  LDFLAGS = "-lcmocka";
}
