{
  inputs = {
    nixpkgs_.url = "github:deemp/flakes?dir=source-flake/nixpkgs";
    nixpkgs.follows = "nixpkgs_/nixpkgs";
    flake-utils_.url = "github:deemp/flakes?dir=source-flake/flake-utils";
    flake-utils.follows = "flake-utils_/flake-utils";
    devshell.url = "github:deemp/flakes?dir=devshell";
    purescript-tools.url = "github:deemp/flakes?dir=language-tools/purescript";
  };

  outputs = inputs: inputs.flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      inherit (inputs.devshell.functions.${system}) mkCommands mkRunCommands mkShell;
      packages = inputs.purescript-tools.packages.${system} // { inherit (pkgs) perl; };
      tools = __attrValues packages;
      devShells.default = mkShell {
        packages = tools;
        bash.extra = ''export LC_ALL=C.UTF-8'';
        commands = mkCommands "tools" tools;
      };
    in
    { inherit devShells; }
  );
}
