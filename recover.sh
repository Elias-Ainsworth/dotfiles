#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

function yesno() {
    local prompt="$1"

    while true; do
        read -rp "$prompt [y/n] " yn
        case $yn in
        [Yy]*)
            echo "y"
            return
            ;;
        [Nn]*)
            echo "n"
            return
            ;;
        *) echo "Please answer yes or no." ;;
        esac
    done
}

BOOTDISK=$(readlink -f /dev/disk/by-label/NIXBOOT)
reformat_boot=$(yesno "Reformat boot?")
if [[ $reformat_boot == "y" ]]; then
    sudo mkfs.fat -F 32 "$BOOTDISK" -n NIXBOOT
fi

# -l prompts for passphrase if needed
echo "Importing zpool"
sudo zpool import -f -l zroot

reformat_nix=$(yesno "Reformat nix?")
if [[ $reformat_nix == "y" ]]; then
    sudo zfs destroy -r zroot/nix

    sudo zfs create -o mountpoint=legacy zroot/nix
    sudo mkdir -p /mnt/nix
    sudo mount -t zfs zroot/nix /mnt/nix
fi

echo "Mounting Disks"

sudo mount --mkdir -t zfs zroot/root /mnt
sudo mount --mkdir "$BOOTDISK" /mnt/boot
sudo mount --mkdir -t zfs zroot/nix /mnt/nix
sudo mount --mkdir -t zfs zroot/tmp /mnt/tmp
sudo mount --mkdir -t zfs zroot/persist /mnt/persist
sudo mount --mkdir -t zfs zroot/cache /mnt/cache

# Get repo to install from
read -rp "Enter flake URL (default: github:elias-ainsworth/dotfiles): " repo
repo="${repo:-github:elias-ainsworth/dotfiles}"

# qol for thorne os
if [[ $repo == "github:elias-ainsworth/dotfiles" ]]; then
    hosts=("desktop" "framework" "x1c" "x1c-8" "t520" "t440" "vm" "vm-hyprland")

    echo "Available hosts:"
    for i in "${!hosts[@]}"; do
        printf "%d) %s\n" $((i + 1)) "${hosts[i]}"
    done

    while true; do
        echo ""
        read -rp "Enter the number of the host to install: " selection
        if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le ${#hosts[@]} ]; then
            host="${hosts[$selection - 1]}"
            break
        else
            echo "Invalid selection. Please enter a number between 1 and ${#hosts[@]}."
        fi
    done
else
    read -rp "Which host to install?" host
fi

# Get git rev
read -rp "Enter git rev for flake (default: main): " git_rev

echo "Re-installing NixOS"
if [[ $repo == "github:elias-ainsworth/dotfiles" ]]; then
    # root password is irrelevant if initialPassword is set in the config
    sudo nixos-install --no-root-password --flake "$repo/${git_rev:-main}#$host" --option tarball-ttl 0
else
    sudo nixos-install --flake "$repo/${git_rev:-main}#$host" --option tarball-ttl 0
fi

echo "Intallation complete. It is now safe to reboot."
