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
          files: \.(c|h)$
          types: [file]
        - id: nixpkgs-fmt
          name: nixpkgs-fmt
          entry: ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt
          language: system
          files: \.nix$
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
    nixpkgs-fmt
    clang-tools
    pre-commit
    statix
    deadnix
    nodePackages.prettier

    # Testing tools
    cppcheck # Static analysis for C
    gcovr # Code coverage
    cmocka # Unit testing framework
  ];

  shellHook = ''
    echo "Entering development shell..."

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
