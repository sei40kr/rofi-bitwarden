{ lib
, jq
, libnotify
, makeWrapper
, rofi
, stdenv
, wl-clipboard
, xsel
}:

stdenv.mkDerivation {
  pname = "rofi-bitwarden";
  version = "1.0.0";

  src = ../..;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ rofi jq libnotify wl-clipboard xsel ];

  installPhase = ''
    install -Dm755 bin/rofi-bitwarden $out/bin/rofi-bitwarden
    install -Dm755 libexec/bitwarden.bash $out/libexec/bitwarden.bash
    wrapProgram $out/bin/rofi-bitwarden --prefix PATH : ${lib.makeBinPath [ rofi jq libnotify rofi wl-clipboard xsel ]}
  '';
}

