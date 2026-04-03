# Base Image
FROM ghcr.io/ublue-os/aurora-dx:beta

RUN dnf install -y ksshaskpass qt ntfs-3g xfsprogs btrfs-progs git cmake make binutils curl wget tmux fpaste unzip tailscale wireguard-tools fpaste wl-clipboard xdg-terminal-exec xhost

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh


RUN rm -rf /var/cache/
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
