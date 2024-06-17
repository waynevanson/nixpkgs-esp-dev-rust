{ version ? "3.1.0"
, callPackage
, lib
, stdenv
, fetchurl
, fetchzip
, runCommand
}:
let
  cargo-espflash-pkg = fetchzip {
    url = "https://github.com/esp-rs/espflash/releases/download/v${version}/cargo-espflash-x86_64-unknown-linux-gnu.zip";
    hash = "sha256-WroIVm/Xfa5aNXAPWzk47ihq25NWlKrn6/ALk7JaR5M="; 
  };
  
  
in
assert stdenv.system == "x86_64-linux";
runCommand "cargo-espflash" {} ''
  mkdir -p $out/bin
  cp ${cargo-espflash-pkg}/cargo-espflash $out/bin/cargo-espflash
  chmod +x $out/bin/cargo-espflash
''

