# Shared build image for SICP translations (tamnd/sicp).
#
# Ships:
#   * XeLaTeX + LaTeX packages for PDF builds.
#   * Texinfo 5.2 (installed from source to /usr/local) so the repo's
#     ./texi2any wrapper and its vendored Texinfo::Convert::HTML.pm
#     work unchanged. The Ubuntu 24.04 apt texinfo is 7.x which is
#     API-incompatible with the 5.x HTML.pm the project depends on.
#   * Node.js + npm + mathjax-full + jsdom for the HTML post-processors
#     (get-math.js, put-math.js, batch-prettify.js) — these replaced the
#     previous phantomjs implementations.
#   * inkscape, Linux Libertine + Inconsolata LGC fonts.
#
# The consumer repo mounts itself at /workspace and runs its own make.

FROM ubuntu:24.04

LABEL org.opencontainers.image.source="https://github.com/tamnd/sicp-docker"
LABEL org.opencontainers.image.description="Build image for tamnd/sicp: XeLaTeX + Texinfo 5.2 + Node MathJax + Inconsolata LGC."
LABEL org.opencontainers.image.licenses="MIT"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    NODE_PATH=/usr/local/lib/node_modules

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    build-essential \
    ca-certificates \
    curl \
    fontconfig \
    fonts-linuxlibertine \
    gettext \
    inkscape \
    latexmk \
    make \
    nodejs \
    npm \
    perl \
    ruby \
    ruby-nokogiri \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-lang-other \
    texlive-latex-extra \
    texlive-latex-recommended \
    texlive-plain-generic \
    texlive-xetex \
    xz-utils \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Build and install Texinfo 5.2 from source into /usr/local.
# The repo's custom ./texi2any looks for Texinfo::Parser at
# /usr/local/share/texinfo, which is exactly where `make install` places
# the Perl modules. Texinfo 5.2 matches the version of the vendored
# Texinfo::Convert::HTML.pm in the source tree.
RUN curl -fsSL https://ftp.gnu.org/gnu/texinfo/texinfo-5.2.tar.gz \
      -o /tmp/texinfo-5.2.tar.gz \
    && tar -xzf /tmp/texinfo-5.2.tar.gz -C /tmp/ \
    && cd /tmp/texinfo-5.2 \
    && ./configure --prefix=/usr/local --disable-nls \
    && make -j"$(nproc)" \
    && make install \
    && cd / \
    && rm -rf /tmp/texinfo-5.2 /tmp/texinfo-5.2.tar.gz

# Node libraries used by the HTML post-processors.
# Installed globally so the consumer repo finds them via NODE_PATH.
RUN npm install -g --omit=dev \
      mathjax-full@3 \
      jsdom@24 \
    && npm cache clean --force

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
