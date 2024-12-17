{ lib
, gitignore
, cairo
, libev
, libX11
, libxcb
, libxkbcommon
, libxkbfile
, meson
, ninja
, pam
, pkg-config
, stdenv
, xcbutilimage
, xcbutilkeysyms
, xcbutilxrm
, xorg
, giflib
}:

let
  inherit (gitignore.lib) gitignoreSource;

  src = gitignoreSource ./.;
in
stdenv.mkDerivation {
  pname = "i3lock-gif";
  version = "2.16.0";

  inherit src;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libxcb
    xcbutilkeysyms
    xcbutilimage
    xcbutilxrm
    pam
    libX11
    libev
    cairo
    libxkbcommon
    libxkbfile
    xorg.xcbutil
    giflib
  ];

  meta = with lib; {
    description = "Simple screen locker like slock";
    longDescription = ''
      Simple screen locker. After locking, a colored background (default: white) or
      a configurable image is shown, and a ring-shaped unlock-indicator gives feedback
      for every keystroke. After entering your password, the screen is unlocked again.
    '';
    homepage = "https://i3wm.org/i3lock/";
    maintainers = with maintainers; [
      malyn
      domenkozar
    ];
    mainProgram = "i3lock";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
