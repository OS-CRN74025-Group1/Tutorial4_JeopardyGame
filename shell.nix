{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Build tools only
    gcc
    gnumake
  ];

  shellHook = ''
    echo "Entering development shell..."
  '';
}
