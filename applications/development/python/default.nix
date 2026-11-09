# Python and Poetry. Their versions are pinned in vars.nix (packageVersions),
# the folder of Poetry's virtual environments is vars.python.venvPath.
# https://www.python.org
# https://python-poetry.org

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
in
{
  environment.systemPackages = [
    python
    poetry
  ];

  # Default folder of the virtual environments Poetry creates (Poetry's
  # virtualenvs.path setting; a project or user config can still override it)
  # https://python-poetry.org/docs/configuration/#virtualenvspath
  environment.variables.POETRY_VIRTUALENVS_PATH = vars.python.venvPath;
}
