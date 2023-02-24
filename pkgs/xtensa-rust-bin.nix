# This version needs to be compatible with the version of ESP-IDF specified in `esp-idf/default.nix`.
{ version ? "1.67.0.0"
, hash ? "sha256-Tk1GQvzlXcMfIkN+yXtDA2BIkK00iKwLGt6eWNlKGsM="
, callPackage
, rust
, lib
, stdenv
, fetchurl
}:

# let
#   fhsEnv = buildFHSUserEnv {
#     name = "xtensa-rust-env";
#     targetPkgs = pkgs: with pkgs; [ zlib libxml2 ];
#     runScript = "";
#   };
# in
let
  component = import {};
  # Remove keys from attrsets whose value is null.
  removeNulls = set:
    removeAttrs set
      (lib.filter (name: set.${name} == null)
        (lib.attrNames set));
  # FIXME: https://github.com/NixOS/nixpkgs/pull/146274
  toRustTarget = platform:
    if platform.isWasi then
      "${platform.parsed.cpu.name}-wasi"
    else
      rust.toRustTarget platform;
  mkComponentSet = callPackage ./rust/mk-component-set.nix {
    inherit toRustTarget removeNulls;
    # src = 

  };
  mkAggregated = callPackage ./rust/mk-aggregated.nix {};
  
  selComponents = mkComponentSet {
    inherit version;
    renames = {};
    platform = "x86_64-linux";
    srcs = {  
      rustc = fetchurl {
        # TODO add the version thing
        url = "https://github.com/esp-rs/rust-build/releases/download/v${version}/rust-${version}-x86_64-unknown-linux-gnu.tar.xz";
        inherit hash;
      };
      rust-src = fetchurl {
        url = "https://github.com/esp-rs/rust-build/releases/download/v${version}/rust-src-${version}.tar.xz";
        hash = "sha256-XwYp3YpVriakdqBCLGns3Od+2UlLFmr912Z8lq/xzo8=";
      };
      
    };

  };
  
in
assert stdenv.system == "x86_64-linux";
# Each is a component
mkAggregated {
  pname = "rust-xtensa";
  # random date
  date = "2023-02-05";
  inherit version;
  availableComponents = selComponents;
  selectedComponents = [ selComponents.rustc selComponents.rust-src ];
}
# stdenv.mkDerivation rec {
#   pname = "xtensa-llvm-toolchain";
#   inherit version;


#   buildInputs = [ makeWrapper ];

#   phases = [ "unpackPhase" "installPhase" ];
#   # TODO .. this is like, way too hard of a derivation for me rn lol
#   installPhase = ''
#     cp -r . $out
#   '';
  
#   meta = with lib; {
#     description = "Xtensa Rust";
#     homepage = "https://github.com/esp-rs/rust-build";
#     license = licenses.mit;
#   };
# }

