<div align="center">
	<img src="https://github.com/gyaru/gyaru/raw/main/lis.png" width="150px" alt="hi">
</div>

# lis' nix config

```nixos-rebuild switch --flake .#radiata --recreate-lock-file --show-trace |& nom```

```darwin-rebuild switch --flake .#carrot --recreate-lock-file --show-trace |& nom```


#### quirks to fix
* ##### do we really need brew? (not yet lol)
* ##### [/home/user can't be deleted and then recreated?](https://github.com/gyaru/nix-config/blob/baea74da6c8c5453bd57bf8eceeb4cc6a4b68e96/hosts/radiata/configuration.nix#L122)