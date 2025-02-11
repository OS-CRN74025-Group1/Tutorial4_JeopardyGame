{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Build tools
    gcc
    gnumake
    gdb
    valgrind
  ];

  shellHook = ''
    echo "Entering development shell..."
  '';
}
