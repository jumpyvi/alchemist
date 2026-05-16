FROM scratch AS ctx
COPY build_files /

# Base Image
FROM ghcr.io/ublue-os/aurora:stable

RUN dnf install -y xfsprogs make papirus-icon-theme git cmake make korganizer kdepim-addons ksshaskpass qt gnome-disks xdg-terminal-exec xhost

RUN dnf config-manager -y addrepo --from-repofile=https://download.opensuse.org/repositories/home:paulmcauley/Fedora_44/home:paulmcauley.repo
RUN dnf install klassy -y


RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

RUN rm -rf /var/cache/
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
