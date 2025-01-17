{ pkgs, listIgnores }:
let
  # aliases for multiple shells in one place,
  # separated into abbrs and aliases for fish
  fishAbbrs = {
    l = "lsd -al";
    ltd = "lt --depth";
    nnn = "nnn -adHe -P p";
    docc = "docker-compose";
    podc = "podman-compose";
    clip = "xclip -sel clip";
    today = "date +%F";
    datetime = "date +%FT%T%z";
    shut = "sudo systemctl poweroff";
    rebo = "sudo systemctl reboot";
    # git
    ga = "git add";
    gc = "git commit -v";
    gl = "git pull";
    gf = "git fetch";
    gco = "git checkout";
    gs = "git switch";
    gre = "git restore";
    gd = "git diff";
    gsh = "git show";
    gsl = "git showl";
    gst = "git status";
    gb = "git branch";
    gsta = "git stash";
    gstp = "git stash pop";
    glg = "git log --stat";
    glga = "git log --stat --graph --all";
    glo = "git log --oneline";
    gloa = "git log --oneline --graph --all";
    grh = "git reset HEAD";
  };
  fishAliases = {
    lt = builtins.concatStringsSep " " (
      [ "lsd --tree -a" ] ++
      (map (i: "-I " + i) listIgnores)
    );
  };
  shellAliases = fishAbbrs // fishAliases;
  nuAliases = shellAliases // {
    # TODO: these don't work with nu 0.79, figure out why
    # today = "(date now | date format \"%F\")";
    # datetime = "(date now | date format \"%FT%T%z\")";

    # still need to overwrite these
    # because the fish versions don't work with nu
    today = "date now";
    datetime = "date now";
  };
  nuAliasesStr = builtins.concatStringsSep "\n"
    (pkgs.lib.mapAttrsToList (k: v: "alias ${k} = ${v}") nuAliases);


  fish = {
    enable = true;
    interactiveShellInit = ''
      if not set -q TMUX
        exec tmux
      end
    '';
    shellAbbrs = fishAbbrs;
    shellAliases = fishAliases;
  };

  nushell = {
    # nushell is not set as login shell because it doesn't have the right
    # environment variable setup and making it by hand is cumbersome.
    # instead, fish is login shell, set up to automatically start tmux,
    # and the tmux default command is set to "exec nu"
    enable = true;
    configFile.text =
      ''
        $env.config = {
          show_banner: false
          edit_mode: vi
          cursor_shape: {
            vi_insert: line
            vi_normal: block
          }
          completions: {
            external: {
              enable: true
              max_results: 100
              completer: {|spans|
                # workaround for a bug with custom completers and aliases in nu v0.77+,
                # see https://www.nushell.sh/cookbook/external_completers.html#alias-completions

                # if the current command is an alias, get it's expansion
                let expanded_alias = (scope aliases | where name == $spans.0 | get -i 0 | get -i expansion)
                # overwrite
                let spans = (if $expanded_alias != null  {
                    # put the first word of the expanded alias first in the span
                    $spans | skip 1 | prepend ($expanded_alias | split row " ")
                } else { $spans })

                carapace $spans.0 nushell $spans
                  | from json
                  | if ($in | default [] | where value == $"($spans | last)ERR" | is-empty) { $in } else { null }
              }
            }
          }
          keybindings: [
            {
              name: fzf_file
              modifier: control
              keycode: char_f
              mode: [emacs, vi_insert, vi_normal]
              event: {
                send: executehostcommand
                # big messy command to wrap the result in ticks only if it has spaces or quotes
                cmd: `commandline edit --insert (fzf --height=50% | str trim | do { let res = $in; if (["'", '"', " "] | any { $in in $res }) { $'`($res)`' } else { $res }})`
              }
            },
            {
              name: fzf_dir
              modifier: alt
              keycode: char_f
              mode: [emacs, vi_insert, vi_normal]
              event: {
                send: executehostcommand
                cmd: `commandline edit --insert (fd --type d | fzf --height=50% | str trim | do { let res = $in; if (["'", '"', " "] | any { $in in $res }) { $'`($res)`' } else { $res }})`
              }
            },
          ]
        }

        ${nuAliasesStr}
      '';
    envFile.text = ''
      # remove indicator chars besides the one provided by starship
      $env.PROMPT_INDICATOR_VI_INSERT = ""
      $env.PROMPT_INDICATOR_VI_NORMAL = ""
      $env.PROMPT_MULTILINE_INDICATOR = "| "
    '';
  };
in
{ inherit nushell fish; }
