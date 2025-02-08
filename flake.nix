{
  description = "Jeopardy Game Project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            gcc
            gnumake
            binutils
          ];

          shellHook = ''
            export LIBRARY_PATH=$LIBRARY_PATH:$PWD
            export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD
            export C_INCLUDE_PATH=$C_INCLUDE_PATH:$PWD
          '';
        };
      }
    );
} 