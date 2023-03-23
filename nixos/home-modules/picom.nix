{}:
{
  enable = true;
  shadow = false;
  fade = true;
  fadeDelta = 4;
  inactiveOpacity = 0.90;
  opacityRules = [
    # Opaque at all times
    "100:class_g = 'firefox'"
    "100:class_g = 'feh'"
    "100:class_g = 'Sxiv'"
    "100:class_g = 'Zathura'"
    "100:class_g = 'Octave'"
    "100:class_g = 'vlc'"
    "100:class_g = 'mpv'"
    "100:class_g = 'obs'"
    "100:class_g = 'Wine'"
    "100:class_g = 'Microsoft Teams - Preview'"
    "100:class_g = 'zoom'"
    "100:class_g = 'krita'"
    "100:class_g = 'PureRef'"
    "100:class_g = 'tabbed'"
    "100:class_g = 'game'"
    # Slightly transparent even when focused
    "95:class_g = 'VSCodium' && focused"
    "95:class_g = 'discord' && focused"
    "95:class_g = 'Spotify' && focused"
    "95:class_g = 'kitty' && focused"
  ];
  settings = {
    blur =
      {
        method = "gaussian";
        size = 10;
        deviation = 5.0;
      };
    blur-background-exclude = [
      "name *= 'rect-overlay'" # teams screenshare overlay
      "name *= 'Peek'"
    ];
  };
  # fixes flickering problems with glx backend
  backend = "xrender";
}
