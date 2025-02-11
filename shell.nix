{ pkgs ? import <nixpkgs> { } }:

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
  ];

  shellHook = ''
    echo "Entering development shell..."
  '';
}
