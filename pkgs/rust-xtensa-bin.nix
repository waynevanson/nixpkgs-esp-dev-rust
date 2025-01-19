{ version ? "1.84.0.0"
, callPackage
, rust
, lib
, stdenv
, fetchurl
}:
let
  component = import { };
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
  mkAggregated = callPackage ./rust/mk-aggregated.nix { };

  selComponents = mkComponentSet {
    inherit version;
    renames = { };
    platform = "x86_64-linux";
    srcs = {
      rustc = fetchurl {
        url = "https://github.com/esp-rs/rust-build/releases/download/v${version}/rust-${version}-x86_64-unknown-linux-gnu.tar.xz";
        hash = "sha256-W2XeX5SLAxyfX6X+vUygPl1ChZPiNGWRyG02vm7+xsQ=";
      };
      rust-src = fetchurl {
        url = "https://github.com/esp-rs/rust-build/releases/download/v${version}/rust-src-${version}.tar.xz";
        hash = "sha256-FYWHR6kv+r9QN2tPkBJ5GcZupA6XSPMRJbxoGRhWRLA=";
      };
    };
  };

in
assert stdenv.system == "x86_64-linux";
mkAggregated {
  pname = "rust-xtensa";
  date = "2025-01-19";
  inherit version;
  availableComponents = selComponents;
  selectedComponents = [ selComponents.rustc selComponents.rust-src ];
}

