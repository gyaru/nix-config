<div align="center">
	<img src="https://github.com/gyaru/gyaru/raw/main/lis.png" width="150px" alt="hi">
</div>

# lis nix flakes

```nixos-rebuild switch --flake .#radiata --recreate-lock-file --show-trace |& nom```


#### quirks to fix
* ##### [systemd-boot.extraFiles not working with lanzaboote?](https://github.com/gyaru/nix-config/blob/baea74da6c8c5453bd57bf8eceeb4cc6a4b68e96/hosts/radiata/configuration.nix#L169)
* ##### [systemd-boot.extraEntries not working with lanzaboote?](https://github.com/gyaru/nix-config/blob/baea74da6c8c5453bd57bf8eceeb4cc6a4b68e96/hosts/radiata/configuration.nix#L170)
* ##### [/home/user can't be deleted and then recreated?](https://github.com/gyaru/nix-config/blob/baea74da6c8c5453bd57bf8eceeb4cc6a4b68e96/hosts/radiata/configuration.nix#L122)