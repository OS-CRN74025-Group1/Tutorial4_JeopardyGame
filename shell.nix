{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    nixpkgs-fmt
    clang-tools
    pre-commit
    statix
    deadnix
    nodePackages.prettier
  ];

  shellHook = ''
    # Tool documentation
    echo "🛠️  Available development tools:"
    echo ""
    echo "  🔧 nixpkgs-fmt - Nix code formatter"
    echo "    nixpkgs-fmt <file>  Format a single file"
    echo ""
    echo "  🔨 clang-format - C/C++ code formatter"
    echo "    clang-format -i <file>  Format a single file"
    echo ""
    echo "  🔄 pre-commit - Git hooks manager"
    echo "    pre-commit run     Run hooks on staged files"
    echo "    pre-commit run -a  Run hooks on all files"
    echo ""

    # Setup git hooks
    if [ -d .git ]; then
      echo "Setting up git hooks..."
      git config --local core.hooksPath .git/hooks/
      pre-commit install --install-hooks
    fi
  '';
}
