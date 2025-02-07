{
  description = "Jeopardy Game Development Environment";

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
            gdb
            valgrind
            clang-tools # For static analysis
          ];

          shellHook = ''
            echo "Jeopardy Game Development Environment"
            echo "Available tools and commands:"
            echo "Build tools:"
            echo "  gcc         - GNU C Compiler"
            echo "  make        - Build automation tool"
            echo "    make        - Build the project"
            echo "    make run    - Build and run the game" 
            echo "    make debug  - Build with debug symbols"
            echo "    make clean  - Clean build artifacts"
            echo ""
            echo "Debug & Analysis tools:"
            echo "  gdb         - GNU Debugger"
            echo "    gdb ./build/jeopardy  - Start debugging session"
            echo "    (gdb) run            - Run the program"
            echo "    (gdb) break <line>   - Set breakpoint"
            echo "    (gdb) next           - Step over"
            echo "    (gdb) step           - Step into"
            echo "    (gdb) quit           - Exit debugger"
            echo ""
            echo "  valgrind    - Memory error detector"
            echo "    valgrind ./build/jeopardy     - Check for memory leaks"
            echo ""
            echo "  clang-tools - Static analysis suite"
            echo "    clang-tidy <file>    - Code analysis"
            echo "    clang-format <file>  - Code formatting"
          '';
        };

        packages.default = pkgs.stdenv.mkDerivation {
          name = "jeopardy-game";
          src = ./.;
          
          buildInputs = with pkgs; [
            gcc
            gnumake
          ];

          buildPhase = ''
            make
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp build/jeopardy $out/bin/
          '';
        };
      }
    );
} 