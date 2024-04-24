<div align="center">
	<img src="https://github.com/gyaru/gyaru/raw/main/lis.png" width="150px" alt="hi">
</div>

# lis flakes

```nixos-rebuild switch --flake .#radiata --recreate-lock-file --show-trace |& nom```

```darwin-rebuild switch --flake .#carrot --recreate-lock-file --show-trace |& nom```


#### quirks to fix
* ##### check if darwin or not for certain home configuration (fonts are named differently?) (firefox styles)
* ##### do we really need brew?
* ##### [/home/user can't be deleted and then recreated?](https://github.com/gyaru/nix-config/blob/baea74da6c8c5453bd57bf8eceeb4cc6a4b68e96/hosts/radiata/configuration.nix#L122)