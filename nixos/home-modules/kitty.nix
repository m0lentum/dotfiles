{ pkgs }:
{
  enable = true;
  font = {
    name = "JetBrains Mono Medium Nerd Font Complete";
    package = pkgs.jetbrains-mono;
  };
  settings = {
    font_size = 11;
    disable_ligatures = "cursor";
    # theme from https://github.com/bluz71/vim-nightfly-colors
    background = "#011627";
    foreground = "#acb4c2";
    cursor = "#9ca1aa";
    color0 = "#1d3b53";
    color1 = "#fc514e";
    color2 = "#a1cd5e";
    color3 = "#e3d18a";
    color4 = "#82aaff";
    color5 = "#c792ea";
    color6 = "#7fdbca";
    color7 = "#a1aab8";
    color8 = "#7c8f8f";
    color9 = "#ff5874";
    color10 = "#21c7a8";
    color11 = "#ecc48d";
    color12 = "#82aaff";
    color13 = "#ae81ff";
    color14 = "#7fdbca";
    color15 = "#d6deeb";
    selection_background = "#b2ceee";
    selection_foreground = "#080808";
  };
}
