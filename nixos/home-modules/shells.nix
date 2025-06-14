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
    l = "ls -a";
    ll = "ls -al";
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
    # the following gets a weird conflict on nixpkgs 25.05,
    # I think the `lsd` package defines some fish aliases by default
    # which include `lt`.
    # can't be bothered to fix because I don't use fish anymore
    # shellAliases = fishAliases;
  };

  nuScripts = builtins.readFile ../../scripts/mkslides.nu;

  nushell = {
    # nushell is not set as login shell because it doesn't have the right
    # environment variable setup and making it by hand is cumbersome.
    # instead, fish is login shell, set up to automatically start tmux,
    # and the tmux default command is set to "exec nu"
    enable = true;
    configFile.text =
      ''
        # wrap a string in ticks if it has spaces. used in fzf keybindings
        def tick-wrap []: string -> string {
          let s = $in
          if (["'", '"', " "] | any { $in in $s }) {
            $'`($s)`'
          } else {
            $s
          }
        }

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
                carapace $spans.0 nushell ...$spans | from json
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
                cmd: `commandline edit --insert (fzf --tmux | str trim | tick-wrap)`
              }
            },
            {
              name: fzf_dir
              modifier: alt
              keycode: char_f
              mode: [emacs, vi_insert, vi_normal]
              event: {
                send: executehostcommand
                cmd: `commandline edit --insert (fd --type d | fzf --tmux | str trim | tick-wrap)`
              }
            },
          ]
        }

        ${nuAliasesStr}

        ${nuScripts}
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
