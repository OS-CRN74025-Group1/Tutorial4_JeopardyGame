{ pkgs ? import <nixpkgs> {} }:

let
  pythonEnv = pkgs.python311.withPackages (ps: with ps; [
    pip
    cookiecutter
    setuptools
  ]);
in
pkgs.mkShell {
  buildInputs = [
    pythonEnv
    pkgs.which
    pkgs.dos2unix  # Add dos2unix for line ending conversion
    pkgs.git
    pkgs.curl
  ];

  shellHook = "
    VENV_DIR=\"$PWD/.venv\"
    export PATH=\"$VENV_DIR/bin:$PATH\"
    export PYTHONPATH=\"$VENV_DIR/lib/python3.11/site-packages:$PYTHONPATH\"

    if [ ! -d \"$VENV_DIR\" ]; then
      ${pythonEnv}/bin/python -m venv \"$VENV_DIR\"
    fi

    if [ -f \"$VENV_DIR/bin/activate\" ]; then
      . \"$VENV_DIR/bin/activate\"
    fi

    echo \"Python environment ready\"
    echo \"Run: cookiecutter gh:grapeot/devin.cursorrules --checkout template\"
  ";
} 