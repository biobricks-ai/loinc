{
  description = "LOINC BioBrick";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
      with import nixpkgs { inherit system; }; {
        devShells.default = mkShell {
          buildInputs = [
            R
            rPackages.purrr
            rPackages.rvest
            rPackages.getPass
            rPackages.dplyr
            rPackages.httr
            rPackages.fs
            rPackages.stringr
            rPackages.vroom
            rPackages.arrow
          ];
        };
      });
}
