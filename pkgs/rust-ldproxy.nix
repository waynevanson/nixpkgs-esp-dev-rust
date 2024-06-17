{version ? "0.3.2"
, callPackage
, lib
, stdenv
, fetchurl
, fetchzip
, runCommand
}:
let
  ldproxy-pkg = fetchzip {
    url = "https://github.com/esp-rs/embuild/releases/download/ldproxy-v${version}/ldproxy-x86_64-unknown-linux-gnu.zip";
    hash = "sha256-ALN/bU6cyu0K3uUeWYL7G+OcuKEONFLy0SpnQQd2EaQ="; 
  };
in
assert stdenv.system == "x86_64-linux";
runCommand "ldproxy" {} ''
  mkdir -p $out/bin
  cp ${ldproxy-pkg}/ldproxy $out/bin/ldproxy
  chmod +x $out/bin/ldproxy
''

