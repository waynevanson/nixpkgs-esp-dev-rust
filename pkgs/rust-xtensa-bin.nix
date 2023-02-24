{ version ? "1.67.0.0"
, callPackage
, rust
, lib
, stdenv
, fetchurl
}:
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
        url = "https://github.com/esp-rs/rust-build/releases/download/v${version}/rust-${version}-x86_64-unknown-linux-gnu.tar.xz";
        hash = "sha256-Tk1GQvzlXcMfIkN+yXtDA2BIkK00iKwLGt6eWNlKGsM=";
      };
      rust-src = fetchurl {
        url = "https://github.com/esp-rs/rust-build/releases/download/v${version}/rust-src-${version}.tar.xz";
        hash = "sha256-XwYp3YpVriakdqBCLGns3Od+2UlLFmr912Z8lq/xzo8=";
      };
      
    };

  };
  
in
assert stdenv.system == "x86_64-linux";
mkAggregated {
  pname = "rust-xtensa";
  date = "2023-01-25";
  inherit version;
  availableComponents = selComponents;
  selectedComponents = [ selComponents.rustc selComponents.rust-src ];
}

