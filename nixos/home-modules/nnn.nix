{ pkgs }:
{
  enable = true;
  package = pkgs.nnn.override ({ withNerdIcons = true; });
  extraPackages = with pkgs; [
    tabbed
    catimg
    ffmpegthumbnailer
    mediainfo
    sxiv
    mpv
    zathura
  ];
  plugins.src = (pkgs.fetchFromGitHub {
    owner = "jarun";
    repo = "nnn";
    rev = "v4.4";
    sha256 = "15w7jjhzyj1fq1c8f956pj7s729w8h3dih2ghxiann68rw4rmlc3";
  }) + "/plugins";
  plugins.mappings = {
    p = "preview-tui";
    P = "preview-tabbed";
    i = "imgview";
    # need the escaped backslash or the $nnn variable disappears during build
    C = "!convert \\$nnn jpeg:- | xclip -sel clip -t image/jpeg*";
    c = "cat \\$nnn | xclip -sel clip*";
  };
}
