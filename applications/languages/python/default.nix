# Python, Poetry, pipx and uv. The Python, Poetry and uv versions are pinned in
# vars.nix (packageVersions), the folder of Poetry's virtual environments is
# vars.python.venvPath.
# https://www.python.org
# https://python-poetry.org
# https://docs.astral.sh/uv

{ config, pkgs, lib, vars ? import ../../../vars.nix { }, ... }:

let
  pythonConf = vars.packageVersions.python;
  poetryConf = vars.packageVersions.poetry;

  # The nixpkgs interpreter of the same minor version (e.g. python313), built
  # from the pinned source. Through `override`, so its patches and its package
  # set match the version.
  versionParts = lib.splitVersion pythonConf.version;
  python =
    let
      self = (pkgs."python${builtins.elemAt versionParts 0}${builtins.elemAt versionParts 1}".override {
        inherit self;
        sourceVersion = {
          major = builtins.elemAt versionParts 0;
          minor = builtins.elemAt versionParts 1;
          patch = builtins.elemAt versionParts 2;
          suffix = "";
        };
        hash = pythonConf.hash;
        # The interpreters used while building (this is a native build, so all
        # of them are this one). Without this, nixpkgs re-creates them from the
        # stock version, but with the hash above, and the download fails.
        __splices = {
          pythonOnBuildForBuild = self;
          pythonOnBuildForHost = self;
          pythonOnBuildForTarget = self;
          pythonOnHostForHost = self;
          pythonOnTargetForTarget = { };
        };
      }).overrideAttrs (old: {
        # nixpkgs' mimetypes.patch (the mime.types file from Nix) only fits the
        # source it was made for; newer releases changed that part of
        # Lib/mimetypes.py. Point the module at the same file by substitution,
        # which fits either; nixpkgs' postPatch then fills in @mime-types@.
        patches = builtins.filter (p: !(lib.hasSuffix "mimetypes.patch" (toString p))) old.patches;
        postPatch = ''
          substituteInPlace Lib/mimetypes.py \
            --replace-fail '"/etc/mime.types",' '"@mime-types@/etc/mime.types",'
        '' + old.postPatch;
      });
    in
    self;

  # Poetry runs on its own Python from nixpkgs. Poetry and poetry-core must have
  # matching versions, so both are pinned. nixpkgs' patches only apply to its
  # own Poetry version and are dropped for any other.
  poetryPython =
    let
      self = pkgs.poetry.python.override (old: {
        inherit self;
        packageOverrides = lib.composeExtensions (old.packageOverrides or (_: _: { })) (pyself: pysuper: {
          poetry-core = pysuper.poetry-core.overridePythonAttrs (core: {
            version = poetryConf.core.version;
            src = pkgs.fetchFromGitHub {
              owner = "python-poetry";
              repo = "poetry-core";
              tag = poetryConf.core.version;
              hash = poetryConf.core.hash;
            };
            patches = lib.optionals (core.version == poetryConf.core.version) (core.patches or [ ]);
          });
          poetry = pysuper.poetry.overridePythonAttrs (poetry: {
            version = poetryConf.version;
            src = pkgs.fetchFromGitHub {
              owner = "python-poetry";
              repo = "poetry";
              tag = poetryConf.version;
              hash = poetryConf.hash;
            };
            patches = lib.optionals (poetry.version == poetryConf.version) (poetry.patches or [ ]);
          });
        });
      });
    in
    self;
  # Wrapped like nixpkgs' poetry (pkgs/by-name/po/poetry/package.nix), so
  # with nixpkgs' versions it is the same package, from the binary cache
  poetry = poetryPython.pkgs.toPythonApplication (poetryPython.pkgs.poetry.overridePythonAttrs (old: {
    doCheck = true;
    # Propagating dependencies leaks them through $PYTHONPATH
    postFixup = ''
      rm $out/nix-support/propagated-build-inputs
    '';
    passthru = (old.passthru or { }) // { python = poetryPython; };
  }));

  # Poetry's wrapper (bin/poetry) puts its own Python first on the PATH, and
  # Poetry creates new project environments with the `python3` it finds there.
  # This copy of the wrapper puts the pinned Python first after that, so new
  # environments use it by default; Poetry itself keeps running on its own.
  # (A second wrapper around it wouldn't work: Poetry's runs last.)
  poetryWithPython = pkgs.symlinkJoin {
    pname = "poetry";
    inherit (poetry) version meta;
    paths = [ poetry ];
    postBuild = ''
      rm $out/bin/poetry
      substitute ${poetry}/bin/poetry $out/bin/poetry \
        --replace-fail 'unset PYTHONPATH' 'unset PYTHONPATH
      PATH=${python}/bin:$PATH'
      chmod +x $out/bin/poetry
    '';
  };

  # nixpkgs' uv with the version from vars.nix; with nixpkgs' version it is the
  # same package, from the binary cache. Its source tag follows the version.
  # buildRustPackage takes the Rust dependencies' hash from its original
  # arguments, so they are fetched here the same way it does, with cargoHash.
  uv = pkgs.uv.overrideAttrs (finalAttrs: old: {
    inherit (vars.packageVersions.uv) version cargoHash;
    src = old.src.override { inherit (vars.packageVersions.uv) hash; };
    cargoDeps = pkgs.rustPlatform.fetchCargoVendor (
      builtins.intersectAttrs (lib.genAttrs [
        "name" "pname" "version" "src" "srcs" "sourceRoot" "cargoRoot"
        "preUnpack" "unpackPhase" "postUnpack"
      ] (_: null)) finalAttrs
      // {
        patches = [ ];
        hash = vars.packageVersions.uv.cargoHash;
      }
    );
  });
in
{
  environment.systemPackages = [
    python
    poetryWithPython
    # Python command-line apps, each in its own virtual environment
    # https://pipx.pypa.io
    pkgs.pipx
    # Package and project manager
    # https://docs.astral.sh/uv
    uv
  ];

  environment.variables = {
    # Default folder of the virtual environments Poetry creates (Poetry's
    # virtualenvs.path setting; a project or user config can still override it)
    # https://python-poetry.org/docs/configuration/#virtualenvspath
    POETRY_VIRTUALENVS_PATH = vars.python.venvPath;
    # Apps installed with pipx run on the pinned Python
    # https://pipx.pypa.io/stable/docs/#pipx-environment
    PIPX_DEFAULT_PYTHON = "${python}/bin/python3";
    # uv uses the pinned Python. The Pythons it would download are built for
    # other Linux distributions and don't run on NixOS, so it doesn't download any
    # https://docs.astral.sh/uv/reference/environment/
    UV_PYTHON = "${python}/bin/python3";
    UV_PYTHON_DOWNLOADS = "never";
  };

  # pipx and `uv tool install` link the apps' commands into ~/.local/bin
  environment.localBinInPath = true;
}
