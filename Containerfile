FROM scratch AS ctx
COPY build_files /

# Base Image
FROM ghcr.io/ublue-os/bluefin:beta

RUN dnf install -y xfsprogs make papirus-icon-theme 


RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

RUN rm -rf /var/cache/

RUN rm -rf /usr/share/gnome-shell/extensions/
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
