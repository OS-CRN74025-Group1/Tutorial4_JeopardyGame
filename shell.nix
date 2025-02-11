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

    # Testing tools
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
