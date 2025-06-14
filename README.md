<div align="center">
	<img src="https://github.com/gyaru/gyaru/raw/main/lis.png" width="150px" alt="hi">
</div>

# lis' nix config

```nixos-rebuild switch --flake .#radiata --show-trace --log-format internal-json -v |& nom --json```

```darwin-rebuild switch --flake .#carrot --show-trace --log-format internal-json -v |& nom --json```

# check filesystem diff
sudo fd --one-file-system --base-directory / --type f --hidden --exclude "{tmp,etc/passwd}"