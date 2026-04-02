FROM ghcr.io/projectbluefin/common:latest AS bluefin-common

FROM scratch AS ctx
COPY build_files /

# Base Image
FROM quay.io/fedora/fedora-silverblue:44

COPY --from=bluefin-common /system_files/shared/etc/* /etc/
COPY --from=bluefin-common /system_files/shared/usr/* /usr/

RUN dnf install -y dnf5-plugins && \
    dnf -y copr enable ublue-os/packages && \
    dnf -y copr disable ublue-os/packages && \
    dnf -y --enablerepo copr:copr.fedorainfracloud.org:ublue-os:packages install uupd

RUN dnf -y remove gnome-software gnome-extensions-app PackageKit PackageKit-command-not-found gnome-software-fedora-langpacks console-login-helper-messages setroubleshoot


RUN dnf -y --setopt=install_weak_deps=False install gcc
COPY --from=ghcr.io/ublue-os/brew:latest /system_files /
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /usr/bin/systemctl preset brew-setup.service && \
    /usr/bin/systemctl preset brew-update.timer && \
    /usr/bin/systemctl preset brew-upgrade.timer

RUN dnf config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-multimedia.repo && \
    dnf -y install --enablerepo=fedora-multimedia ffmpeg libavcodec @multimedia gstreamer1-plugins-{bad-free,bad-free-libs,good,base} lame{,-libs} && \
    dnf -y install cups sane-backends-drivers-scanners hplip && \
    dnf -y install ntfs-3g xfsprogs btrfs-progs gvfs-mtp gvfs-smb open-vm-tools-desktop zram-generator

RUN dnf install -y git cmake make binutils curl wget tmux ddcutil podman distrobox fpaste unzip tailscale wireguard-tools fpaste wl-clipboard xdg-terminal-exec xhost

RUN dnf install -y evolution evolution-ews

RUN dnf install -y qemu-kvm libvirt virt-install

RUN dnf -y --setopt=install_weak_deps=False install gcc

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

RUN systemctl enable firewalld.service fwupd.service brew-setup.service systemd-resolved.service gdm.service tailscaled.service uupd.timer && \
    systemctl disable mcelog.service

RUN authselect enable-feature with-silent-lastlog

RUN sed -i 's|uupd|& --disable-module-distrobox|' /usr/lib/systemd/system/uupd.service

RUN mkdir -p /etc/flatpak/remotes.d && \
     curl --retry 3 -o /etc/flatpak/remotes.d/flathub.flatpakrepo "https://dl.flathub.org/repo/flathub.flatpakrepo"

RUN rm -rf /var/cache/
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
