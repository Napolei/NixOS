# Microsoft ODBC drivers 17 and 18 for SQL Server, for pyodbc and other ODBC
# clients. They are registered in /etc/odbcinst.ini under their usual names,
# e.g. DRIVER={ODBC Driver 18 for SQL Server}.
# https://learn.microsoft.com/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server

{ config, pkgs, lib, ... }:

{
  environment.unixODBCDrivers = with pkgs.unixodbcDrivers; [
    msodbcsql17
    msodbcsql18
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
