{ nixpkgs ? import ./nix/nixpkgs.nix, ghcVersion ? "ghc902" }:
let
  myHaskellPackages = nixpkgs.haskell.packages.${ghcVersion};

  drv = myHaskellPackages.callCabal2nix "hello-haskell-nix" ./. { };

  shellDrv = myHaskellPackages.shellFor {
    withHoogle = true;
    packages = p: [ drv ];
    buildInputs = with myHaskellPackages;
      [
        cabal-install
        hlint
        ghcid
        haskell-language-server
        stylish-haskell
      ];
  };
in
if nixpkgs.lib.inNixShell then shellDrv else drv
