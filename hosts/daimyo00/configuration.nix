environment.systemPackages = with pkgs; [
# ... existing packages ...
# Pre-commit and related tools
pre-commit
nixpkgs-fmt
clang-tools # for clang-format
python3Packages.pre-commit-hooks # Contains end-of-file-fixer and other hooks
];
