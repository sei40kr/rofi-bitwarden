{
  inputs = {
    nixpkgs.url = "nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, nixpkgs }:
    let
      inherit (flake-utils.lib) eachSystem;
      systems = [ "x86_64-darwin" "x86_64-linux" ];
    in
    eachSystem systems (system:
      let pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          rofi-bitwarden = pkgs.callPackage ./packages/rofi-bitwarden { };
        };
      }
    );
}
