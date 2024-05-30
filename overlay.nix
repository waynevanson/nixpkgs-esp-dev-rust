final: prev:
rec {
  esp-idf-full = prev.callPackage ./pkgs/esp-idf { };

  esp-idf-esp32 = esp-idf-full.override {
    toolsToInclude = [
      "xtensa-esp32-elf"
      "esp32ulp-elf"
      "openocd-esp32"
      "xtensa-esp-elf-gdb"
    ];
  };

  esp-idf-riscv = esp-idf-full.override {
    toolsToInclude = [
      "riscv32-esp-elf"
      "openocd-esp32"
      "riscv32-esp-elf-gdb"
    ];
  };
in
{
  # ESP32C3
  gcc-riscv32-esp32c3-elf-bin = prev.callPackage ./pkgs/esp32c3-toolchain-bin.nix { };
  # ESP32S2
  gcc-xtensa-esp32s2-elf-bin = prev.callPackage ./pkgs/esp32s2-toolchain-bin.nix { };
  # ESP32S3
  gcc-xtensa-esp32s3-elf-bin = prev.callPackage ./pkgs/esp32s3-toolchain-bin.nix { };
  # ESP32
  gcc-xtensa-esp32-elf-bin = prev.callPackage ./pkgs/esp32-toolchain-bin.nix { };
  openocd-esp32-bin = prev.callPackage ./pkgs/openocd-esp32-bin.nix { };

  esp-idf-esp32c3 = esp-idf-riscv;

  esp-idf-esp32s2 = esp-idf-full.override {
    toolsToInclude = [
      "xtensa-esp32s2-elf"
      "esp32ulp-elf"
      "openocd-esp32"
      "xtensa-esp-elf-gdb"
    ];
  };
  # LLVM
  llvm-xtensa = prev.callPackage ./pkgs/llvm-xtensa-bin.nix { };
  # Rust
  rust-xtensa = (import ./pkgs/rust-xtensa-bin.nix { rust = prev.rust; callPackage = prev.callPackage; lib = prev.lib; stdenv = prev.stdenv; fetchurl = prev.fetchurl; });

  esp-idf-esp32s3 = esp-idf-full.override {
    toolsToInclude = [
      "xtensa-esp32s3-elf"
      "esp32ulp-elf"
      "openocd-esp32"
      "xtensa-esp-elf-gdb"
    ];
  };

  esp-idf-esp32c6 = esp-idf-riscv;

  esp-idf-esp32h2 = esp-idf-riscv;

  # ESP8266
  gcc-xtensa-lx106-elf-bin = prev.callPackage ./pkgs/esp8266-rtos-sdk/esp8266-toolchain-bin.nix { };
  esp8266-rtos-sdk = prev.callPackage ./pkgs/esp8266-rtos-sdk/esp8266-rtos-sdk.nix { };
}
