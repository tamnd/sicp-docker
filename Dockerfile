# Shared build image for SICP Vietnamese translation (tamnd/sicp).
#
# Ships XeLaTeX + texi2any + inkscape + Inconsolata LGC font.
# The consumer repo mounts itself at /workspace and runs its own make.

FROM ubuntu:24.04

LABEL org.opencontainers.image.source="https://github.com/tamnd/sicp-docker"
LABEL org.opencontainers.image.description="Build image for tamnd/sicp: XeLaTeX + texi2any + inkscape + Inconsolata LGC."
LABEL org.opencontainers.image.licenses="MIT"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    fontconfig \
    fonts-linuxlibertine \
    inkscape \
    latexmk \
    make \
    perl \
    ruby \
    ruby-nokogiri \
    texinfo \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-latex-extra \
    texlive-latex-recommended \
    texlive-plain-generic \
    texlive-xetex \
    xz-utils \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Install Inconsolata LGC (OpenType) so fontspec can find it by name.
RUN curl -fsSL \
      "https://github.com/MihailJP/Inconsolata-LGC/releases/download/LGC-2.002/InconsolataLGC-OT-2.002.tar.xz" \
      -o /tmp/InconsolataLGC.tar.xz \
    && mkdir -p /tmp/inconsolata-lgc /usr/local/share/fonts/inconsolata-lgc \
    && tar -xf /tmp/InconsolataLGC.tar.xz -C /tmp/inconsolata-lgc/ \
    && find /tmp/inconsolata-lgc -name "*.otf" \
         -exec install -Dm644 {} /usr/local/share/fonts/inconsolata-lgc/ \; \
    && rm -rf /tmp/inconsolata-lgc /tmp/InconsolataLGC.tar.xz \
    && fc-cache -fv

WORKDIR /workspace

CMD ["bash"]
