<div align="center">

# elysia-on-nix

*The launcher for anime games on Linux, packaged for NixOS!* 💕

<img src="assets/pictures/ak-e.png" alt="Launcher" width="600"/>

> ⚠️ Elysia is still in very early development! Please report any issues. ⚠️

> ⚠️ This specific package is communnity managed ⚠️

<img src="assets/elysia-on-nix.png" alt="Elysia Launcher" width="200"/>

</div>

## Installation

### NixOS Flakes

Add the following to your flake.nix inputs
```
elysia = {
  url = "git+https://dawn.wine/foxtrottt/elysia-on-nix/";
  inputs.nixpkgs.follows = "nixpkgs";
};
```
Then add the following
```
environment.systemPackages = [
  inputs.elysia.packages.x86_64-linux.default
  ];
```
or, if you prefer it under Home-Manager
```
home.packages = [
  inputs.elysia.packages.x86_64-linux.default
  ];
```



## Support

Elysia is still very work-in-progress: if you meet any bugs, please make an issue or ask for help at [our discord server!](https://discord.gg/ck37X6UWBp)