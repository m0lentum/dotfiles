{ pkgs, pkgsUnstable }:
let
  git = {
    enable = true;
    userName = "Mikael Myyrä";
    userEmail = "mikael@molentum.me";
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
      ".nlsp-settings"
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
      user.email = "mikael@molentum.me";
      ui.default-command = "log";
      # make sure the pager only pages overflowing messages
      ui.pager = [ "less" "-FRX" ];
      colors = {
        description = "green";
        working_copy = { underline = true; };
      };
      aliases = {
        bup = [ "bookmark" "set" "-r" "@-" ];
        la = [ "log" "-r" ".." ];
        ld = [ "log" "--template" "builtin_log_detailed" "--stat" ];
        lad = [ "log" "-r" ".." "--template" "builtin_log_detailed" "--stat" ];
        gf = [ "git" "fetch" ];
      };
      revsets = {
        log = pkgs.lib.strings.concatStringsSep " | " [
          # show a bit of extra context even if editing trunk
          "ancestors(@, 5)"
          # show the entire distance from trunk to current even if it's longer than 5
          "immutable_heads()-..@"
          # show all of my own digressions even if I never made them into a branch
          "ancestors(visible_heads() & mine(), 2)"
          # show a bit of all local branches
          "ancestors(bookmarks(), 2)"
        ];
      };
      snapshot.max-new-file-size = "15M";
    };
  };

in
{ inherit git jujutsu; }

