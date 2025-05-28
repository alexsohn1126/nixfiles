final: prev:
let
  spotx = prev.fetchurl {
    url = "https://raw.githubusercontent.com/SpotX-Official/SpotX-Bash/c3d4b777081b3cdb52d52b43ac1589c349c87173/spotx.sh";
    hash = "sha256-Nw3aVhzACr41ZahUr6cXODkED9U7AxTVEc4AF/sqGkc=";
  };
in
{
  spotify = prev.spotify.overrideAttrs (old: {
    nativeBuildInputs =
      old.nativeBuildInputs
      ++ (with prev; [
        util-linux
        perl
        unzip
        zip
        curl
      ]);

    unpackPhase =
      builtins.replaceStrings
        [ "runHook postUnpack" ]
        [
          ''
            patchShebangs --build ${spotx}
            runHook postUnpack
          ''
        ]
        old.unpackPhase;

    installPhase =
      builtins.replaceStrings
        [ "runHook postInstall" ]
        [
          ''
            bash ${spotx} -f -P "$out/share/spotify"
            runHook postInstall
          ''
        ]
        old.installPhase;
  });
}
