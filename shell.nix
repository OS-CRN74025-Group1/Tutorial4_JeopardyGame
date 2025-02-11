{ pkgs ? import <nixpkgs> { } }:

let
  pre-commit-config = pkgs.writeText "pre-commit-config.yaml" ''
    repos:
    - repo: local
      hooks:
        - id: clang-format
          name: clang-format
          entry: ${pkgs.clang-tools}/bin/clang-format -i
          language: system
          files: jeopardy-source/.*\.(c|h)$
          types: [file]
        - id: alejandra
          name: alejandra
          entry: ${pkgs.alejandra}/bin/alejandra
          language: system
          files: \.nix$
          types: [file]
        - id: statix
          name: statix
          entry: ${pkgs.statix}/bin/statix fix
          language: system
          files: \.nix$
          types: [file]
        - id: deadnix
          name: deadnix
          entry: ${pkgs.deadnix}/bin/deadnix -e
          language: system
          files: \.nix$
          types: [file]
        - id: prettier
          name: prettier
          entry: ${pkgs.nodePackages.prettier}/bin/prettier --write
          language: system
          files: \.(md|yaml|json)$
          types: [file]
  '';
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    # Build tools
    gcc
    gnumake
    gdb
    valgrind

    # Formatters and linters
    clang-tools
    alejandra
    statix
    deadnix
    nodePackages.prettier
    pre-commit

    # Testing tools
    cppcheck
    gcovr
    cmocka
  ];

  shellHook = ''
    echo "🎮 Welcome to Jeopardy Game Development Environment"
    echo ""
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
    echo "    alejandra    - Nix formatter"
    echo "    statix       - Nix linter"
    echo "    deadnix      - Find dead Nix code"
    echo "    prettier     - Format markdown/yaml/json"
    echo ""
    echo "  🔄 Git hooks:"
    echo "    pre-commit run     - Run hooks on staged files"
    echo "    pre-commit run -a  - Run hooks on all files"
    echo ""

    if [ -d .git ]; then
      echo "Setting up pre-commit hooks..."
      cp ${pre-commit-config} .pre-commit-config.yaml
      pre-commit uninstall || true
      pre-commit clean || true
      pre-commit install || true
    fi
  '';

  # Environment variables for development
  CFLAGS = "-Wall -Wextra -g -O2";
  LDFLAGS = "-lcmocka";
}
