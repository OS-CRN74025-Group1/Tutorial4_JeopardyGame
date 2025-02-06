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
            # Build tools
            gnumake
            gcc

            # Version control
            git

            # Optional but useful development tools
            gdb     # For debugging
            valgrind # For memory analysis
            
            # Python and pip
            python314
            python314Packages.pip
          ];

          shellHook = ''
            echo -e "\033[1;34mC Development Environment\033[0m"
            echo -e "\033[1;32mAvailable tools: gcc, make, git, gdb, valgrind, python, pip\033[0m"
            echo -e "\033[1;32mPython version: $(python --version) \033[0m"
            echo -e "\033[1;32mPip version: $(pip --version) \033[0m"
          '';
        };
      }
    );
} 