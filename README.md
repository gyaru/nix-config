<div align="center">
	<img src="https://github.com/gyaru/gyaru/raw/main/lis.png" width="150px" alt="hi">
</div>

# lis' nix config

modular nixos & home-manager configuration with impermanence

## hosts
- **radiata** - desktop (hyprland, amd)
- **carrot** - macbook (nix-darwin)

## quick start
```bash
nix develop
gyaru switch  # rebuild current host
```

## gyaru commands
- `gyaru switch` - rebuild & switch
- `gyaru test` - test config without bootloader
- `gyaru check` - validate flake
- `gyaru impermanence` - check what dies on reboot

## structure
```
├── flake.nix        # entrypoint
├── hosts/           # machine-specific
├── home/            # user configs
├── modules/         # reusable nixos modules
├── pkgs/            # custom packages
└── scripts/         # helpers (gyaru)
```

## modules
- **audio** - pipewire w/ device config
- **wayland** - compositor agnostic portal setup
- **impermanence** - btrfs rollback on boot
- **desktop** - kernel tweaks & base desktop stuff
- **gaming** - steam, gamemode, etc

modular by design - enable what you need per host