{
  inputs.flakes.url = "github:deemp/flakes";
  outputs = inputs:
    let flakes = inputs.flakes; in
    flakes.makeFlake {
      inputs = {
        inherit (flakes.all) nixpkgs devshell purescript-tools;
      };
      perSystem = { inputs, system }:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          inherit (inputs.devshell.lib.${system}) mkCommands mkShell;
          packages = inputs.purescript-tools.packages.${system} // { inherit (pkgs) perl; };
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
