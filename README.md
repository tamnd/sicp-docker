# sicp-docker

Shared Docker build image for [tamnd/sicp](https://github.com/tamnd/sicp) — a Vietnamese translation of *Structure and Interpretation of Computer Programs*.

Published to GitHub Container Registry: `ghcr.io/tamnd/sicp-docker`

## What's inside

- Ubuntu 24.04
- XeLaTeX (texlive-xetex, texlive-latex-extra, texlive-latex-recommended, texlive-fonts-extra, texlive-plain-generic)
- latexmk
- texi2any (texinfo)
- inkscape
- Inconsolata LGC OpenType font (from [MihailJP/Inconsolata-LGC](https://github.com/MihailJP/Inconsolata-LGC))
- Linux Libertine fonts
- perl, ruby, ruby-nokogiri, zip (for epub/HTML build pipeline)

## Usage

```bash
docker run --rm -v "$PWD:/workspace" ghcr.io/tamnd/sicp-docker:latest \
  make -C /workspace/src/pdf
```

## Rebuilds

The image rebuilds automatically on the first day of every month, and on any change to the Dockerfile.
