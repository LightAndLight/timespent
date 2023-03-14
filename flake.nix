{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
    ipso.url = "github:LightAndLight/ipso?tag=v0.5";
  };
  outputs = { self, nixpkgs, flake-utils, nix-filter, ipso }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = import nixpkgs { inherit system; };
      in rec {
        packages = {
          ipso = ipso.defaultPackage.${system};
        };
        
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            packages.ipso
          ];
        };
        
        defaultPackage = pkgs.callPackage ./timespent.nix {
          inherit nix-filter;
          ipso = packages.ipso;
        };
      }
    );
}
