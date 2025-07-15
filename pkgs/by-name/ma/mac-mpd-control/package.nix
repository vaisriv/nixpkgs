{
  # lib & utils
  lib,
  fetchFromGitHub,
  cmake,
  stdenv,
  nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "mac-mpd-control";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "stengland";
    repo = "mac-mpd-control";
    # pinned rev for now, as tagged major version is very old
    # tag = "v${version}";
    rev = "4cf9f462d6a7800ff38aa79ee57e7c4011030667";
    hash = "sha256-HMk3hU3eKhaWCDHJRJGNRR+YMhSwfTxNDy97Wk8fcF4=";
  };

  nativeBuildInputs = [ cmake ];

  # buildPhase = ''
  #   make all
  # '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/mpdcontrold $out/bin/mpdcontrold

    mkdir -p $out/LaunchAgents
    cp skel/at.fox21.mpdcontrold.plist $out/LaunchAgents/at.fox21.mpdcontrold.plist
    substituteInPlace $out/LaunchAgents/at.fox21.mpdcontrold.plist \
      --replace "/var/empty/local/bin/" "$out/bin/"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    platforms = lib.platforms.darwin;
    changelog = "https://github.com/theOehrly/timple/releases/tag/v${version}";
    description = "Extended functionality for plotting timedelta-like values with Matplotlib";
    homepage = "https://github.com/theOehrly/timple";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vaisriv or "vai" ];
  };
}
