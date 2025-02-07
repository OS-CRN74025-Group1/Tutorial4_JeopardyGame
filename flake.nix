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
          ] ++ platformSpecificInputs;

          shellHook = ''
            if [ -n "$PS1" ]; then
              echo -e "\033[1;34mC Development Environment\033[0m"
              echo -e "\033[1;32mAvailable tools: gcc, make, git\033[0m"
              if [ "$(uname)" = "Linux" ]; then
                echo -e "\033[1;32mDebug tools: gdb, valgrind\033[0m"
              fi
            fi
          '';
        };
      }
    );
} 