# Rust Fork

## `@waynevanson`

There's a lot of forking going on here that needs to be explained.
It's up to date as of `2025-09-07`.

| Repo                                   | Branch              | Explanation                                                                                                                 |
| :------------------------------------- | :------------------ | :-------------------------------------------------------------------------------------------------------------------------- |
| `waynevanson/nixpkgs-esp-dev-rust`     | `main`              | Attempts to update inputs related [ESP `rust-build`](https://github.com/esp-rs/rust-build) from `1.86.0.0` to `1.88.0.0`, fixes build issues and syncs with mirrexagon esp-idf changes.  |
| `aljazerzen/nixpkgs-esp-dev-rust`      | `esp32`             | Add ESP32 nix shell, update from `1.80.0.0` to `1.86.0.0`.                                                                  |
| `hsel-netsys/nixpkgs-esp-dev-rust`     | `update_and_esp32s` | No changes in 1 year. Merge stuff from upstream mirrexagon fork with `esp-idf` updates.                                     |
| `thiskappaisgrey/nixpkgs-esp-dev-rust` | `rust`              | No changed in 2 years. The base for implemented rust support `esp-rs`, `esp-idf` as nix packages and nix shells in a flake. |
| `mirrexagon/nixpkgs-esp-dev`           | `<default>`         | Up to date implementation of `esp-idf` in a nix module. Supports most of the esp32 series.                                  |

What's odd is that instead of importing from the `mirrexagon` repository, all these forks were made.

I think what should've happened is that `esp-rs` organisation should implement nix modules.
That way they're always up to date.

Looks like there's discussion about it [here on esp-rs/rust-build](https://github.com/esp-rs/rust-build/issues/289).

## Someone else

- Add support for using the [esp-rs fork](https://github.com/esp-rs/rust-build) of Rust to support the Xtensa Architecture processors for esp32 (ESP32-S2 and ESP32-S3).
- Checkout the `esp32s2-idf-rust` devShell (meant as a nix replacement to [espup](https://github.com/esp-rs/espup) ). The reason why I removed `esp-idf` from that shell is that the [esp-idf-sys](https://github.com/esp-rs/esp-idf-sys) crate automatically clones `esp-idf` and expects it to be a git repository. It also installs the python dependencies automatically through `virtualenv`. I'd imagine supporting `esp32s3` would be similar, but I haven't tested it myself.

## Other notes

- I copied some code from [rust-overlay](https://github.com/oxalica/rust-overlay), located in the `pkgs/rust` directory.

# nixpkgs-esp-dev

ESP8266 and ESP32(-C2, -C3, -S2, -S3, -C6, -H2) packages and development environments for Nix.

This repo contains derivations for ESP-IDF, and most of the toolchains and tools it depends on (compilers for all supported targets, custom OpenOCD for Espressif chips, etc.).

Released into the public domain via CC0 (see `COPYING`).

## Getting started

### `nix develop`

The easiest way to get started is to run one of these commands to get a development shell, without even needing to download the repository (requires Nix 2.4 or later):

- `nix --experimental-features 'nix-command flakes' develop github:mirrexagon/nixpkgs-esp-dev#esp32-idf`: for ESP32 development with [esp-idf](https://github.com/espressif/esp-idf).
  - Includes the ESP32 toolchain, and downloads and sets up ESP-IDF with everything ready to use `idf.py`.
- `nix --experimental-features 'nix-command flakes' develop github:mirrexagon/nixpkgs-esp-dev#esp8266-rtos-sdk`: for ESP8266 development with [ESP8266_RTOS_SDK](https://github.com/espressif/ESP8266_RTOS_SDK).
  - Includes the ESP8266 toolchain, ESP8266_RTOS_SDK, and esptool.
- `nix --experimental-features 'nix-command flakes' develop github:mirrexagon/nixpkgs-esp-dev#esp8266-nonos-sdk`: for ESP8266 development with [ESP8266_NONOS_SDK](https://github.com/espressif/ESP8266_NONOS_SDK).
  - Includes the ESP8266 toolchain, ESP8266_NONOS_SDK, and esptool.

The list of available shells (to go after the `#` in the command) are:

- `esp-idf-full`: Includes toolchains for _all_ supported ESP32 chips (no ESP8266).
- `esp32-idf`: Includes toolchain for the ESP32.
- `esp32c2-idf`: Includes toolchain for the ESP32-C2.
- `esp32c3-idf`: Includes toolchain for the ESP32-C3.
- `esp32s2-idf`: Includes toolchain for the ESP32-S2.
- `esp32s3-idf`: Includes toolchain for the ESP32-S3.
- `esp32c6-idf`: Includes toolchain for the ESP32-C6.
- `esp32h2-idf`: Includes toolchain for the ESP32-H2.
- `esp32p4-idf`: Includes toolchain for the ESP32-P4.
- `esp8266-rtos-sdk`: Includes RTOS SDK toolchain for ESP8266 and esptool.
- `esp8266-nonos-sdk`: Includes NONOS SDK toolchain for ESP8266 and esptool.

### `nix-shell`

If you're not using Nix 2.4+ or prefer not to need to enable flakes, you can clone the repo and use one of:

- `nix-shell shells/esp32-idf-full.nix`
- `nix-shell shells/esp32-idf.nix`
- `nix-shell shells/esp32c2-idf.nix`
- `nix-shell shells/esp32c3-idf.nix`
- `nix-shell shells/esp32s2-idf.nix`
- `nix-shell shells/esp32s3-idf.nix`
- `nix-shell shells/esp32c6-idf.nix`
- `nix-shell shells/esp32h2-idf.nix`
- `nix-shell shells/esp32p4-idf.nix`
- `nix-shell shells/esp8266-rtos-sdk.nix`
- `nix-shell shells/esp8266-nonos-sdk.nix`

to get the same shells as with `nix develop`.

Note: `nix develop` will use the nixpkgs revision specified in `flake.nix`/`flake.lock`, while using `nix-shell` will use your system nixpkgs by default.

## Creating a custom shell environment

You can create a standalone `shell.nix` for your project that downloads `nixpkgs-esp-dev` automatically and creates a shell with the necessary packages and environment setup to use ESP-IDF.

See `examples/shell-standalone.nix` for an example.

## Accessing ESP-IDF Examples

ESP-IDF comes with many example projects that demonstrate various features and capabilities. These examples are accessible as Nix packages through the `examples` attribute of each ESP-IDF package. The examples are organized in a nested attribute set that mirrors the directory structure of ESP-IDF's `examples` directory.

### Building an example

You can build any example using `nix build` with the appropriate attribute path:

```bash
# Format: .#esp-idf-full.examples.<target>.<path>.<to>.<example>
nix build .#esp-idf-full.examples.esp32.get-started.hello_world
```

This will build the "hello_world" example for the ESP32 target. The resulting package includes a flash script that can be used to flash the example to your device:

```bash
./result/bin/esp32-get-started-hello_world-flash
```

The flashing script is set as the derivation's main program, making it possible to directly run build and flash the firmware with `nix run`.

```bash
nix run .#esp-idf-full.examples.esp32.get-started.hello_world
```

Additional arguments (such as `--port`) are passed directly to `esptool.py`

## Overriding ESP-IDF and ESP32 toolchain versions

There is a default version of ESP-IDF specified in `pkgs/esp-idf/default.nix`. To use a different version of ESP-IDF or to pin the version, override a `esp-idf-*` derivations with the desired version and the hash for it. The correct version of the tools will be downloaded automatically.

NOTE: This doesn't quite work as it should - Python packages won't be adapted for the version you override to. See https://github.com/mirrexagon/nixpkgs-esp-dev/issues/25

See `examples/shell-override-versions.nix` for an example.

### Note about `IDF_VER`

This is a macro describing the version used while building provided by the ESP-IDF toolchain. It is normally generated using `git describe`, but for underlying reasons the build environment can't have access to this git metadata. Fortunately, this repo can emulate this by overriding it to equal the `rev` argument given to `pkgs/esp-idf/default.nix`. This is however not perfect as the output would differ from `git describe` when `rev` is set to a commit hash instead of a tag.

## Overlay

This repo contains an overlay in `overlay.nix` containing all the packages defined by this repo. If you clone the repo into `~/.config/nixpkgs/overlays/`, nixpkgs will automatically pick up the overlay and effectively add the packages to your system nixpkgs.
