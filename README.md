# Alchemist

💙 This uses [zirconium-mkosi](https://github.com/zirconium-dev/zirconium) bootc profiles and as a template for many things, thank you

# Purpose

Minimal and unbranded MkOSI AlmaLinux (Kitten) bootable container with ublue-like core utilies


## Workstation

☁️ Based on almalinux:10

Mkosi almalinux image

### Changes:
- Up to date and minimal gnome install (Gnome 50 from TunaOS)
- Virtualization support
- Uupd (From ublue)
- Necessary drivers, codecs and utils (From negativo and Bluefin-LTS)
- Brew, flathub and gnome-nightly ootb


# How to rebase

```bash
sudo bootc switch --enforce-container-sigpolicy "ghcr.io/jumpyvi/alchemist:latest"
```

# Huge thanks
- https://github.com/tulilirockz/zirconium-mkosi
- https://github.com/tuna-os/tunaOS
- https://github.com/bootcrew
- https://github.com/ublue-os/bluefin-lts