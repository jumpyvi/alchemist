FROM scratch AS ctx
COPY build_files /

# Base Image
FROM ghcr.io/ublue-os/bluefin:beta

RUN dnf install -y xfsprogs make yaru-theme papirus-icon-theme 

RUN dnf -y remove "gnome-shell-extension*" --setopt=clean_requirements_on_remove=False

RUN dnf -y remove gnome-shell-extension-blur-my-shell gnome-shell-extension-dash-to-dock gnome-shell-extension-appindicator gnome-shell-extension-logo-menu gnome-shell-extension-caffeine 

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

RUN rm -rf /var/cache/
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
