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
            glibc
            git
            dos2unix
          ];

          shellHook = ''
            # Force LF line endings
            git config --local core.autocrlf false
            git config --local core.eol lf
            
            # Convert all text files to LF
            find . -type f -name "Makefile" -exec dos2unix {} \;
            find . -type f -name "*.c" -exec dos2unix {} \;
            find . -type f -name "*.h" -exec dos2unix {} \;
            find . -type f -name "*.nix" -exec dos2unix {} \;
            
            # Set environment variables
            export LIBRARY_PATH=$LIBRARY_PATH:$PWD
            export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD:${pkgs.glibc}/lib
            export C_INCLUDE_PATH=$C_INCLUDE_PATH:$PWD
            
            # Set locale to UTF-8
            export LANG=C.UTF-8
            export LC_ALL=C.UTF-8

            # Ensure executable permission
            if [ -f jeopardy ]; then
              chmod +x jeopardy
            fi
          '';
        };
      }
    );
} 