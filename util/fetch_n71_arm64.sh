#!/bin/bash
set -e

# winarm64 is BtbN's own n7.1 build, renamed to this release's scheme. linuxarm64 is built from
# this tree instead, because upstream's has no VAAPI.
TAG="autobuild-2026-07-31-14-10"
OUT="$(realpath -m "${1:-artifacts}")"
mkdir -p "$OUT"

gh release download "$TAG" -R BtbN/FFmpeg-Builds -D "$OUT" \
    -p 'ffmpeg-n7.1.*-winarm64-gpl-shared-7.1.zip'

cd "$OUT"
mv ffmpeg-n7.1.*-winarm64-gpl-shared-7.1.zip ffmpeg-n7.1-winarm64-gpl-shared.zip

gh release download n7.1 -R CutWire-Studios/FFmpeg-Builds -p checksums.sha256 --clobber
sed -i -E '/winarm64-gpl-shared/d' checksums.sha256
sha256sum ffmpeg-n7.1-winarm64-gpl-shared.zip >> checksums.sha256
