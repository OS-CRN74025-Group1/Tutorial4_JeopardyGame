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
        
        # Define the jeopardy package
        jeopardy = pkgs.stdenv.mkDerivation {
          pname = "jeopardy";
          version = "0.1.0";
          src = ./.;
          
          nativeBuildInputs = with pkgs; [
            gcc
            gnumake
            binutils
          ];
          
          buildPhase = ''
            make clean
            make all
          '';
          
          installPhase = ''
            mkdir -p $out/bin
            cp jeopardy $out/bin/
            chmod +x $out/bin/jeopardy
          '';
        };
      in
      {
        packages = {
          default = jeopardy;
          jeopardy = jeopardy;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Core build tools
            gcc
            gnumake
            binutils
            glibc
            
            # Development tools
            gdb
            valgrind
            clang-tools # for static analysis
            
            # Version control and utilities
            git
            dos2unix
          ];

          shellHook = ''
            # Force LF line endings and convert existing files
            git config --local core.autocrlf false
            git config --local core.eol lf
            
            # Convert all text files to LF
            find . -type f -name "Makefile" -exec dos2unix {} + || true
            find . -type f -name "*.c" -exec dos2unix {} + || true
            find . -type f -name "*.h" -exec dos2unix {} + || true
            find . -type f -name "*.nix" -exec dos2unix {} + || true
            
            # Set environment variables
            export LIBRARY_PATH=$LIBRARY_PATH:$PWD
            export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD:${pkgs.glibc}/lib
            export C_INCLUDE_PATH=$C_INCLUDE_PATH:$PWD
            
            # Set locale to UTF-8
            export LANG=C.UTF-8
            export LC_ALL=C.UTF-8
            
            # Print development environment info
            echo "Jeopardy Game Development Environment"
            echo "--------------------------------"
            echo "Available commands:"
            echo "  make clean     - Clean build artifacts"
            echo "  make all       - Build the game"
            echo "  gdb jeopardy   - Debug the game"
            echo "  valgrind ./jeopardy - Check for memory leaks"
            echo "--------------------------------"
          '';
        };
      }
    );
} 