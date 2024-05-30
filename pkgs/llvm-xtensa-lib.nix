{ version ? "17.0.1_20240419"
, hash ? "sha256-oOEVonjgssLp9qhrHrEwlNQpXOB18LnUgUUe5RlU6Sw="
, stdenv
, lib
, fetchurl
, makeWrapper
, buildFHSUserEnv
}:

let
  fhsEnv = buildFHSUserEnv {
    name = "xtensa-toolchain-env";
    targetPkgs = pkgs: with pkgs; [ zlib libxml2 ];
    runScript = "";
  };
in

assert stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  pname = "xtensa-llvm-toolchain";
  inherit version;
  src = fetchurl {
    url = "https://github.com/espressif/llvm-project/releases/download/esp-${version}/libs-clang-esp-${version}-x86_64-linux-gnu.tar.xz";
    inherit hash;
  };

  buildInputs = [ makeWrapper ];

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    cp -r . $out
  '';

  meta = with lib; {
    description = "Xtensa LLVM tool chain libraries";
    homepage = "https://github.com/espressif/llvm-project";
    license = licenses.gpl3;
  };
}

