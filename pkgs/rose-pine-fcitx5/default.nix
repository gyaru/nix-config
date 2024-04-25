{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "rose-pine-fcitx5";
  version = "0.0.1";
  dontConfigue = true;

  src = fetchFromGitHub {
    owner = "rose-pine";
    repo = "fcitx5";
    rev = "148de09929c2e2f948376bb23bc25d72006403bc";
    hash = "sha256-SpQ5ylHSDF5KCwKttAlXgrte3GA1cCCy/0OKNT1a3D8=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/usr/share/fcitx5/themes/rose-pine-dawn rose-pine-dawn/radio.png rose-pine-dawn/arrow.png rose-pine-dawn/theme.conf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Soho vibes for fcitx5";
    homepage = "https://github.com/rose-pine/fcitx5";
    maintainers = with maintainers; [gyaru];
    platforms = platforms.all;
    license = licenses.ofl;
  };
}
