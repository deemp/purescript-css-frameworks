{
  inputs.flakes.url = "github:deemp/flakes";
  inputs.purescript-overlay.url = "github:thomashoneyman/purescript-overlay";
  outputs = inputs:
    let flakes = inputs.flakes; purescript-overlay = inputs.purescript-overlay; in
    flakes.makeFlake {
      inputs = {
        inherit (flakes.all) nixpkgs devshell purescript-tools;
      };
      perSystem = { inputs, system }:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          inherit (inputs.devshell.lib.${system}) mkCommands mkShell;
          packages = inputs.purescript-tools.packages.${system} // {
            inherit (pkgs) perl;
            inherit (purescript-overlay.packages.${system}) spago;
          };
          tools = __attrValues packages;
          devShells.default = mkShell {
            packages = tools;
            bash.extra = ''export LC_ALL=C.UTF-8'';
            commands = mkCommands "tools" tools;
          };
        in
        { inherit devShells; };
    };
}
