# Elias Ainsworth's NixOS Config (forked from iynaix/dotfiles)

This config is intended to be used with NixOS. There is _experimental_ support
for running the dotfiles on
[legacy operating systems](https://github.com/elias-ainsworth/dotfiles/blob/main/home-manager.md).

## Features

- Multiple NixOS configurations, including desktop, laptops and VM
- Persistence via impermanence (both `/` and `/home`)
- Automatic ZFS snapshots with rotation
- Flexible NixOS / Home Manager config via feature flags
- sops-nix for managing secrets
- Hyprland / niri with waybar setup, with screen capture
- Dynamic colorschemes using wallust (pywal, but maintained)

## How to Install

Run the following commands from a terminal on a NixOS live iso / from a tty on
the minimal iso.

The following install script partitions the disk, sets up the necessary datasets
and installs NixOS.

From a standard ISO,

```sh
sh <(curl -L https://raw.githubusercontent.com/elias-ainsworth/dotfiles/main/install.sh)
```

From the custom iso built via `nbuild-iso ISO_HOST`,

```sh
thorneos-install
```

Reboot

<details>
<summary><h4>Creating Persist Snapshot to Restore</h4></summary>

```sh
sudo zfs snapshot zroot/persist@persist-snapshot
sudo zfs send zroot/persist@persist-snapshot > SNAPSHOT_FILE_PATH
```

</details>

<details>
<summary><h4>Restoring from Persist Snapshot</h4></summary>

```sh
# the rename is needed for encrypted datasets, as -F doesn't work
sudo zfs receive -o mountpoint=legacy zroot/persist-new < SNAPSHOT_FILE_PATH
sudo zfs rename zroot/persist zroot/persist-old
sudo zfs rename zroot/persist-new zroot/persist
```

</details>

## System Rescue

Run the following commands from a terminal on a NixOS live iso / from a tty on
the minimal iso.

The following script optionally reformats the boot partition and / or /nix
dataset, then reinstalls NixOS.

From a standard ISO,

```sh
sh <(curl -L https://raw.githubusercontent.com/elias-ainsworth/dotfiles/main/recover.sh)
```

From the custom iso built via `nbuild-iso ISO_HOST`,

```sh
thorneos-recover
```

## Adding a New Host

NOTE: This can be done all within the live iso with a git clone but it's easier
to do it on a system with a development environment already setup.

Create a new directory in `hosts/` with the new hostname, in the same format as
the other hosts.

Boot into the live iso on the new system and run
`nixos-generate-config --no-filesystems --show-hardware-config`.

Copy the output onto a pastebin or similar, replacing
`hosts/NEW_HOSTNAME/hardware.nix` with the pastebin contents, preferably on the
other system.

Push the updated config to git, then proceed with installation using the
instructions from [How to Install](#how-to-install) above.

## Credits

- _Grandmaster_ [@iynaix](https://github.com/iynaix) (Lin Xianyi), for being the
  author of the original nix [config](https://github.com/iynaix/dotfiles) I
  ~~stole~~ forked and for bearing with my idiotic questions over on Vimjoyer's
  discord server.
- Followed by _Master_ [@diniamo](https://github.com/diniamo) for inspiring
  [@chomky](https://github.com/justchokingaround), which then inspired my first
  (non-functional) nix configuration.
- Also many thanks to [@zen](https://github.com/71zenith) for his help over at
  the ani-cli support discord server and for the fact that I copy-pasted his
  entire [config](https://github.com/71zenith/kiseki) for my first functional
  nix [configuration](https://github.com/elias-ainsworth/thorne).
- Further thanks to [Vimjoyer](https://www.youtube.com/@vimjoyer) for his very
  helpful YouTube videos, traversing Nix at the beginning would have been
  infinitely harder if it weren't for this absolute chad.
- And in general many many thanks to everyone on the Vimjoyer and ani-cli
  support discord servers. This idiot would not have been able to do jack shit
  without your help.
- Finally, to the person I owe the most thanks, **God**. For giving everyone a
  _smidge_ more patience so that their heads wouldn't blow while trying to deal
  with my stupidity.
