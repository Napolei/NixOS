# Microsoft ODBC drivers 17 and 18 for SQL Server, for pyodbc and other ODBC
# clients. They are registered in /etc/odbcinst.ini under their usual names,
# e.g. DRIVER={ODBC Driver 18 for SQL Server}.
# https://learn.microsoft.com/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server

{ config, pkgs, lib, ... }:

let
  # nixpkgs' msodbcsql17 is 17.7, which only loads OpenSSL 1.1; OpenSSL 3
  # (nixpkgs' openssl) is supported from 17.10. The override keeps nixpkgs'
  # unpack and install steps, which only work for major version 17.
  # Releases: https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod/pool/main/m/msodbcsql17/
  msodbcsql17 = pkgs.unixodbcDrivers.msodbcsql17.overrideAttrs (old: rec {
    versionMajor = "17";
    versionMinor = "11";
    versionAdditional = "1.1";
    version = "${versionMajor}.${versionMinor}.${versionAdditional}-1";

    src = pkgs.fetchurl {
      url = "https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod/pool/main/m/msodbcsql17/msodbcsql17_${version}_amd64.deb";
      hash = "sha256-EcvcC8P2frnBky+Y3R6rGdSH76dypTw7LnPBkhR9pcA=";
    };

    postFixup = ''
      patchelf --set-rpath ${
        lib.makeLibraryPath [
          pkgs.unixodbc
          pkgs.openssl
          pkgs.libkrb5
          pkgs.libuuid
          pkgs.stdenv.cc.cc
        ]
      } $out/lib/libmsodbcsql-${versionMajor}.${versionMinor}.so.${versionAdditional}
    '';

    # Name and library path for /etc/odbcinst.ini; nixpkgs' still name the
    # 17.7 library
    passthru = (old.passthru or {}) // {
      fancyName = "ODBC Driver 17 for SQL Server";
      driver = "lib/libmsodbcsql-${versionMajor}.${versionMinor}.so.${versionAdditional}";
    };
  });
in
{
  environment.unixODBCDrivers = [
    msodbcsql17
    pkgs.unixodbcDrivers.msodbcsql18
  ];

  # unixODBC's tools: `odbcinst -q -d` lists the drivers, `isql` connects
  environment.systemPackages = [ pkgs.unixodbc ];

  # pyodbc from PyPI links against libodbc.so.2 and libstdc++.so.6 but doesn't
  # bring them, and Nix-built programs (like the pinned Python) only find
  # libraries on their own paths or here
  environment.variables.LD_LIBRARY_PATH = [
    "${lib.getLib pkgs.unixodbc}/lib"
    "${lib.getLib pkgs.stdenv.cc.cc}/lib"
  ];
}
