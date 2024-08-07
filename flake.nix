{
  description = "lis' nix flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgs-nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    #flake-utils.url = "github:numtide/flake-utils";
    #agenix.url = "github:ryantm/agenix";
    #agenix.inputs.nixpkgs.follows = "nixpkgs";
    #agenix-rekey.url = "github:oddlama/agenix-rekey";
    #agenix-rekey.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    ags.url = "github:Aylur/ags";
    ags.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
  };

  outputs = {
    self,
    nixpkgs,
    darwin,
    #agenix,
    #agenix-rekey,
    home-manager,
    impermanence,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = ["x86_64-linux" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages =
      forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    formatter =
      forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit inputs;};

    nixosModules = import ./modules/nixos;

    # host configs
    nixosConfigurations = {
      radiata = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/radiata/configuration.nix
          inputs.lanzaboote.nixosModules.lanzaboote
          #agenix.nixosModules.default
          #agenix-rekey.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.lis = import ./home/lis.nix;
          }
        ];
      };
    };
    darwinConfigurations = {
      carrot = darwin.lib.darwinSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/carrot/configuration.nix
          home-manager.darwinModules.home-manager
          {
            nixpkgs.overlays = [inputs.nixpkgs-firefox-darwin.overlay];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.bun = import ./home/bun.nix;
          }
        ];
      };
    };
  };
}
