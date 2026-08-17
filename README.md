# CutWire FFmpeg 7.1 builds

Fork of [BtbN/FFmpeg-Builds](https://github.com/BtbN/FFmpeg-Builds) used by
[Drift](https://github.com/CutWire-Studios/Drift) to pin **one** FFmpeg version:
**7.1, gpl-shared**, for **linux64** and **win64**.

This is not a daily autobuild mirror. BtbN dropped n7.1 from their moving
`latest` tag on 2026-08-17 (they now ship n8.1 / n9.0 / master). Drift still
needs 7.1 because Qt 6.10.3’s QtMultimedia ffmpeg backend is FFmpeg 7.1.3 —
Drift and Qt both load libav\* in-process, so the soversion has to match.

GitHub Actions is disabled on this fork. Rebuild locally if the pin ever needs
refreshing:

```bash
./makeimage.sh linux64 gpl-shared 7.1
./build.sh     linux64 gpl-shared 7.1

./makeimage.sh win64 gpl-shared 7.1
./build.sh     win64 gpl-shared 7.1
```

Artifacts land in `artifacts/`. Publish them as the `n7.1` release.

The current `n7.1` release is the last BtbN n7.1 gpl-shared autobuild
(`n7.1.5-16-g9a4bb2c579`, `autobuild-2026-08-16-13-00`), renamed to stable
filenames. Checksums are in `checksums.sha256` on that release.

---

Original BtbN documentation follows.

# FFmpeg Static Auto-Builds

Static Windows (x86_64) and Linux (x86_64) Builds of ffmpeg master and latest release branch.

Windows builds are targetting Windows 7 and newer, provided UCRT is installed.
The minimum supported version is Windows 10 22H2, no guarantees on anything older.

Linux builds are targetting RHEL/CentOS 8 (glibc-2.28 + linux-4.18) and anything more recent.

## Package List

For a list of included dependencies check the scripts.d directory.
Every file corresponds to its respective package.

## How to make a build

### Prerequisites

* bash
* docker

### Build Image

* `./makeimage.sh target variant [addin [addin] [addin] ...]`

### Build FFmpeg

* `./build.sh target variant [addin [addin] [addin] ...]`

On success, the resulting zip file will be in the `artifacts` subdir.

### Targets, Variants and Addins

Available targets:
* `win64` (x86_64 Windows)
* `win32` (x86 Windows)
* `linux64` (x86_64 Linux, glibc>=2.28, linux>=4.18)
* `linuxarm64` (arm64 (aarch64) Linux, glibc>=2.28, linux>=4.18)

The linuxarm64 target will not build some dependencies due to lack of arm64 (aarch64) architecture support or cross-compiling restrictions.

* `davs2` and `xavs2`: aarch64 support is broken.
* `libmfx` and `libva`: Library for Intel QSV, so there is no aarch64 support.

Available variants:
* `gpl` Includes all dependencies, even those that require full GPL instead of just LGPL.
* `lgpl` Lacking libraries that are GPL-only. Most prominently libx264 and libx265.
* `nonfree` Includes fdk-aac in addition to all the dependencies of the gpl variant.
* `gpl-shared` Same as gpl, but comes with the libav* family of shared libs instead of pure static executables.
* `lgpl-shared` Same again, but with the lgpl set of dependencies.
* `nonfree-shared` Same again, but with the nonfree set of dependencies.

All of those can be optionally combined with any combination of addins:
* `4.4`/`5.0`/`5.1`/`6.0`/`6.1`/`7.0`/`7.1` to build from the respective release branch instead of master.
* `debug` to not strip debug symbols from the binaries. This increases the output size by about 250MB.
* `lto` build all dependencies and ffmpeg with -flto=auto (HIGHLY EXPERIMENTAL, broken for Windows, sometimes works for Linux)
