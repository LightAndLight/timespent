{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
    ipso.url = "github:LightAndLight/ipso";
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
        
        defaultPackage = pkgs.stdenv.mkDerivation {
          name = "timespent";
          src = nix-filter.lib {
            root = ./.;
            include = [
              "template.csv"
              "timespent"
            ];
          };
          
          buildInputs = [
            packages.ipso
          ];

          nativeBuildInputs = [
            pkgs.makeWrapper
          ];
          
          buildPhase = "true";
          
          installPhase = ''
            mkdir -p $out/bin
            
            # `patchShebangs` in `fixupPhase` only runs for executable files
            chmod +x timespent 
            cp timespent $out/bin
            
            cp template.csv $out
          ''; 

          postFixup = ''
            wrapProgram $out/bin/timespent \
              --set TEMPLATE_FILE $out/template.csv
          '';
        };
      }
    );
}
