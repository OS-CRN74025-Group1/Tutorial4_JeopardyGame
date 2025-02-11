{
  description = "Tutorial 4 - Jeopardy Game";

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
        packages.default = pkgs.stdenv.mkDerivation {
          name = "jeopardy-game";
          src = ./jeopardy-source;
          buildInputs = with pkgs; [ gcc gnumake ];
          buildPhase = "make";
          installPhase = ''
            mkdir -p $out/bin
            cp bin/jeopardy $out/bin/
          '';
        };

        devShells.default = pkgs.mkShell {
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
              # Remove any existing hooks
              rm -f .git/hooks/*
            
              # Install pre-commit hooks
              pre-commit install --install-hooks || true
            fi
          '';

          CFLAGS = "-Wall -Wextra -g -O2";
          LDFLAGS = "-lcmocka";
        };

        formatter = pkgs.alejandra;
      });
}
