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
        
        # Platform-specific dependencies
        platformSpecificInputs = with pkgs;
          if stdenv.isLinux then [
            gdb
            valgrind
          ] else [];
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Build tools
            gnumake
            gcc

            # Version control
            git
            
            # Python and pip
            python314
            python314Packages.pip
          ] ++ platformSpecificInputs;

          shellHook = ''
            echo -e "\033[1;34mC Development Environment\033[0m"
            echo -e "\033[1;32mAvailable tools: gcc, make, git, python, pip\033[0m"
            if [ "$(uname)" = "Linux" ]; then
              echo -e "\033[1;32mDebug tools: gdb, valgrind\033[0m"
            fi
            echo -e "\033[1;32mPython version: $(python --version) \033[0m"
            echo -e "\033[1;32mPip version: $(pip --version) \033[0m"
          '';
        };
      }
    );
} 