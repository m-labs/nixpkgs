{ stdenv, lib, fetchurl, makeWrapper, python3, nixosTests }:

stdenv.mkDerivation rec {
  pname = "bazarr";
  version = "0.9";

  src = fetchurl {
    url = "https://github.com/morpheus65535/bazarr/archive/v${version}.tar.gz";
    sha256 = "106f0gagq81rwykppyfjc7q8ibq3j89lp08hqgbmcv26hxb89rbj";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/src
    cp -r * $out/src

    mkdir -p $out/bin
    makeWrapper "${(python3.withPackages (ps: [ps.lxml ps.numpy])).interpreter}" \
      $out/bin/bazarr \
      --add-flags "$out/src/bazarr.py" \
  '';

  passthru.tests = {
    smoke-test = nixosTests.bazarr;
  };

  meta = with lib; {
    description = "Subtitle manager for Sonarr and Radarr";
    homepage = "https://www.bazarr.media/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ xwvvvvwx ];
    platforms = platforms.all;
  };
}
