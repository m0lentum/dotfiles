{ pkgs, pkgsUnstable }:
let
  git = {
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
      rebase.autosquash = true;
      rebase.autostash = true;
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
  };

  jujutsu = {
    enable = true;
    package = pkgsUnstable.jujutsu;
    settings = {
      user.name = "Mikael Myyrä";
      user.email = "mikael.myyrae@gmail.com";
      ui.default-command = "log";
      # make sure the pager only pages overflowing messages
      ui.pager = [ "less" "-FRX" ];
      colors = {
        description = "green";
        working_copy = { underline = true; };
      };
      aliases = {
        bup = [ "branch" "set" "-r" "@-" ];
        la = [ "log" "-r" ".." ];
        ld = [ "log" "--template" "builtin_log_detailed" "--stat" ];
        lad = [ "log" "-r" ".." "--template" "builtin_log_detailed" "--stat" ];
        gf = [ "git" "fetch" ];
      };
      revsets = {
        # compared to default, show fewer branches (local only)
        # and always a few ancestors even if editing trunk
        log = "ancestors(@, 5) | immutable_heads()-..@ | ancestors(branches(), 2)";
      };
      snapshot.max-new-file-size = "15M";
    };
  };

in
{ inherit git jujutsu; }

