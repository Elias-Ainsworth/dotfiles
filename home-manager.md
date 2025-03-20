# Elias Ainsworth's Home Manager Config

### Install Nix on Other Linux Distros

```sh
sh <(curl -L https://nixos.org/nix/install) --daemon
```

### Install Home Manager

```sh
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```

### Run Home Manager

Substitute `desktop` with desired host

```sh
mkdir -p ~/projects
cd ~/projects
git clone https://github.com/elias-ainsworth/dotfiles
cd dotfiles
nix-shell -p home-manager
NIXPKGS_ALLOW_UNFREE=1 home-manager --extra-experimental-features "nix-command flakes" switch --flake ".#desktop"
```

Reboot.

### TODO

- gtk theme doesn't seem to be working
- hyprland stuff
  - hyprland
  - swww
  - waybar
- kanagawa stuff
  - cursors
  - [gtk](https://search.nixos.org/packages?channel=24.11&show=kanagawa-gtk-theme&from=0&size=50&sort=relevance&type=packages&query=kanagawa)
    (pkgs.kanagawa-gtk-theme)
  - [icons](https://search.nixos.org/packages?channel=24.11&show=kanagawa-gtk-theme&from=0&size=50&sort=relevance&type=packages&query=kanagawa)
    (pkgs.kanagawa-icon-theme)
  - [qt](https://github.com/LuDreamst/Kanagawa-Kvantum)
  - rofi
  - [tmux](https://github.com/LNybkox/tmux-kanagawa)
  - [vscode](https://github.com/Lmetaphore/kanagawa-vscode-color-theme)
  - wallust
- niri stuff
  - [ags](https://aylur.github.io/ags/)
  - [astal](https://aylur.github.io/astal/)
  - [niri](https://github.com/sodiboo/niri-flake)
  - wallpaper.rs rewrite
- rofi menu rust rewrites?
