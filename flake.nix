{
  description = "Encrypt a git repo using age";

  inputs.nixpkgs.url =  "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      version = "0.2.4";
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          git-age = pkgs.buildGoModule {
            inherit version;
            pname = "git-age";

            src = pkgs.fetchFromGitHub {
              owner = "prskr";
              repo = "git-age";
              rev = "v${version}";
              sha256 = "sha256-+9wcQ0U4UPky4167xPuRCtDTUKp1dgzFU5NiFTlted0=";
            };

            vendorHash = "sha256-LpeEdOs7qrwdxzN2l0ISgfY5JED/pvsGuHq1MQ2AUes=";
          };
        });

      defaultPackage = forAllSystems (system: self.packages.${system}.git-age);
    };
}
