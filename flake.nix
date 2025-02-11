{
  description = "Tutorial 4 - Jeopardy Game";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, pre-commit-hooks }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          alejandra.enable = true;
          deadnix.enable = true;
          statix.enable = true;
          clang-format = {
            enable = true;
            types_or = [ "c" "c++" "header" ];
          };
        };
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        name = "jeopardy-dev";

        packages = with pkgs; [
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

          # Testing tools
          cppcheck
          gcovr
          cmocka
        ];

        shellHook = ''
          echo "🎮 Welcome to Jeopardy Game Development Environment"
          ${pre-commit-check.shellHook}
        '';

        CFLAGS = "-Wall -Wextra -g -O2";
        LDFLAGS = "-lcmocka";
      };

      formatter.${system} = pkgs.alejandra;
    };
}
