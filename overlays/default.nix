{inputs, ...}: {
  additions = final: _prev: import ../pkgs final;

  modifications = _: _: {
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
}
