{ pkgs }:
{
  enable = true;
  userName = "Mikael Myyrä";
  userEmail = "mikael.myyrae@gmail.com";
  signing.signByDefault = true;
  signing.key = "EBDEF166B95A3FB8";
  ignores = [
    "*.nogit*"
    ".envrc"
    ".direnv"
    ".vscode"
    ".vim"
    "Session.vim"
    "compile_commands.json"
    ".cache"
  ];
  lfs.enable = true;
  delta.enable = true;
  extraConfig = {
    pull.rebase = true;
    fetch.prune = true;
    diff.colorMoved = "zebra";
    init.defaultBranch = "main";
    merge.tool = "nvim";
    mergetool.nvim.cmd = ''nvim "$MERGED"'';
    mergetool.prompt = false;
    mergetool.keepBackup = false;
  };
  aliases = {
    fixup = pkgs.lib.concatStrings [
      "!git log -n 50 --pretty=format:'%h %s' --no-merges "
      "| fzf | cut -c -7 "
      "| xargs -o git commit --fixup"
    ];
    chpick = pkgs.lib.concatStrings [
      "!git log --all -n 50 --pretty=format:'%h %s' --no-merges "
      "| fzf | cut -c -7 "
      "| xargs -o git cherry-pick"
    ];
    showl = pkgs.lib.concatStrings [
      "!git log --all -n 50 --pretty=format:'%h %s' --no-merges "
      "| fzf | cut -c -7 "
      "| xargs -o git show"
    ];
  };
}
