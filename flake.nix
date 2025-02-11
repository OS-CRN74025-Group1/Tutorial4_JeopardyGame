{
  description = "Jeopardy Game Project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, pre-commit-hooks }:
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

          # Add checks for common build issues
          doCheck = true;
          checkPhase = ''
            gcc -Wall -Wextra -Werror -fsyntax-only *.c
          '';

          buildPhase = ''
            make clean
            make all
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp jeopardy $out/bin/
            chmod +x $out/bin/jeopardy
          '';

          meta = with pkgs.lib; {
            description = "A C-based Jeopardy game implementation";
            homepage = "https://github.com/OS-CRN74025-Group1/tutorial4_jeopardygame";
            license = licenses.mit;
            platforms = platforms.all;
            maintainers = [ ];
          };
        };

        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt = {
              enable = true;
            };
            clang-format = {
              enable = true;
              types = [ "c" "header" ];
            };
            trailing-whitespace = {
              enable = true;
              entry = "trailing-whitespace-fixer";
              types = [ "text" ];
            };
            end-of-file-fixer = {
              enable = true;
              entry = "end-of-file-fixer";
              types = [ "text" ];
            };
            check-merge-conflict = {
              enable = true;
              entry = "check-merge-conflict";
              types = [ "text" ];
            };
          };
        };

      in
      rec {
        packages = {
          default = jeopardy;
          jeopardy = jeopardy;
        };

        checks = {
          inherit pre-commit-check;
          build = jeopardy;
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # Core build tools
            gcc
            gnumake
            binutils
            glibc

            # Development tools
            gdb
            valgrind
            clang-tools
            nixpkgs-fmt
            python3
            pre-commit

            # Version control and utilities
            git
            dos2unix

            # Documentation
            man
            man-pages
            man-pages-posix
          ] ++ (with self.checks.${system}.pre-commit-check; enabledPackages);

          shellHook = self.checks.${system}.pre-commit-check.shellHook + ''
                        # Reset git hooks path
                        git config --unset-all core.hooksPath || true
            
                        # Ensure .git/hooks directory exists
                        mkdir -p .git/hooks
            
                        # Remove any existing hooks first
                        rm -f .git/hooks/pre-commit
                        rm -f .git/hooks/pre-push
                        rm -f .git/hooks/pre-merge-commit
                        rm -f .git/hooks/prepare-commit-msg
            
                        # Get absolute paths for Nix environment
                        NIX_PROFILE="/etc/profiles/per-user/$USER"
                        PRE_COMMIT_BIN=$(which pre-commit)
            
                        # Create hook files with proper Nix environment sourcing
                        cat > .git/hooks/pre-commit << EOF
            #!/usr/bin/env bash
            export PATH="$NIX_PROFILE/bin:$PATH"
            export NIX_PROFILES="$NIX_PROFILE"
            if [ -f "$PRE_COMMIT_BIN" ]; then
                exec "$PRE_COMMIT_BIN" run --hook-stage pre-commit
            else
                echo "Warning: pre-commit not found in PATH"
                exit 1
            fi
            EOF

                        cat > .git/hooks/pre-push << EOF
            #!/usr/bin/env bash
            export PATH="$NIX_PROFILE/bin:$PATH"
            export NIX_PROFILES="$NIX_PROFILE"
            if [ -f "$PRE_COMMIT_BIN" ]; then
                exec "$PRE_COMMIT_BIN" run --hook-stage pre-push
            else
                echo "Warning: pre-commit not found in PATH"
                exit 1
            fi
            EOF

                        cat > .git/hooks/pre-merge-commit << EOF
            #!/usr/bin/env bash
            export PATH="$NIX_PROFILE/bin:$PATH"
            export NIX_PROFILES="$NIX_PROFILE"
            if [ -f "$PRE_COMMIT_BIN" ]; then
                exec "$PRE_COMMIT_BIN" run --hook-stage pre-merge-commit
            else
                echo "Warning: pre-commit not found in PATH"
                exit 1
            fi
            EOF

                        cat > .git/hooks/prepare-commit-msg << EOF
            #!/usr/bin/env bash
            export PATH="$NIX_PROFILE/bin:$PATH"
            export NIX_PROFILES="$NIX_PROFILE"
            if [ -f "$PRE_COMMIT_BIN" ]; then
                exec "$PRE_COMMIT_BIN" run --hook-stage prepare-commit-msg -- "$@"
            else
                echo "Warning: pre-commit not found in PATH"
                exit 1
            fi
            EOF

                        # Make hooks executable
                        chmod +x .git/hooks/*
            
                        # Configure Git to use local hooks
                        git config core.hooksPath .git/hooks
            
                        # Install pre-commit hooks
                        pre-commit install --install-hooks --overwrite
            
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
                        echo ""
                        echo "🎮 Jeopardy Game Development Environment"
                        echo "----------------------------------------"
                        echo "📋 Available commands:"
                        echo "  make clean              - Clean build artifacts"
                        echo "  make all                - Build the game"
                        echo "  ./jeopardy              - Run the game"
                        echo ""
                        echo "🔧 Development tools:"
                        echo "  gdb jeopardy            - Debug the game"
                        echo "  valgrind ./jeopardy     - Check for memory leaks"
                        echo "  clang-format -i *.c *.h - Format code"
                        echo ""
                        echo "📚 Documentation:"
                        echo "  man 3 <function>        - View C function documentation"
                        echo ""
          '';
        };
      }
    );
}
