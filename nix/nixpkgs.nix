let
   bootstrap = import <nixpkgs> {};

   nixpkgs = bootstrap.lib.importJSON ./nixpkgs.json;

   src = bootstrap.fetchFromGitHub {
     owner = "NixOS";
     repo = "nixpkgs";
     inherit (nixpkgs) rev sha256;
   };
 in import src {}
