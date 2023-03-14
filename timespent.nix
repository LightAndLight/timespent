{ stdenv, nix-filter, ipso, makeWrapper, templateFile ? "$out/template.csv" }: stdenv.mkDerivation {
  name = "timespent";
  src = nix-filter.lib {
    root = ./.;
    include = [
      "template.csv"
      "timespent"
    ];
  };
  
  buildInputs = [
    ipso
  ];

  nativeBuildInputs = [
    makeWrapper
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
      --set TEMPLATE_FILE ${templateFile}
  '';
}
