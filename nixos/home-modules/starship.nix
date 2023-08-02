{ pkgs }:
{
  enable = true;
  settings = {
    format = pkgs.lib.concatStrings [
      "$username"
      "$hostname"
      "$directory"
      "$git_branch"
      "$git_state"
      "$git_status"
      "$rust"
      "$cmd_duration"
      "$line_break"
      "$jobs"
      "$battery"
      "$nix_shell"
      "$character"
    ];
    cmd_duration.min_time = 1;
    directory.fish_style_pwd_dir_length = 1;
    git_status = {
      ahead = "⇡$count";
      diverged = "⇕⇡$ahead_count⇣$behind_count";
      behind = "⇣$count";
      modified = "*";
    };
    nix_shell = {
      format = "[$state ]($style)";
      impure_msg = "λ";
      pure_msg = "λλ";
    };
    package.disabled = true;
  };
}
