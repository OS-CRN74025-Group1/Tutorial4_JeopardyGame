{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Build tools
    gnumake
    gcc

    # Version control
    git

    # Optional but useful development tools
    gdb     # For debugging
    valgrind # For memory analysis
    
    #github:grapeot/devin.cursorrules pre-reqs
    python314
  ];

  shellHook = ''
    echo -e "\033[1;34mC Development Environment\033[0m"
    echo -e "\033[1;32mAvailable tools: gcc, make, git, gdb, valgrind, python314\033[0m"
  '';
}
