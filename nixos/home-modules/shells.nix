{ pkgs, pkgsUnstable, listIgnores }:
let
  # aliases for multiple shells in one place,
  # separated into abbrs and aliases for fish
  fishAbbrs = {
    l = "lsd -al";
    ltd = "lt --depth";
    nnn = "nnn -adHe -P p";
    docc = "docker-compose";
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
    # changes come frequently enough and make big enough changes to online docs
    # to warrant getting the version on unstable
    package = pkgsUnstable.nushell;
    configFile.text =
      ''
        let-env config = {
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
                # see https://github.com/nushell/nushell/issues/8483
                let has_alias = ($nu.scope.aliases | where name == $spans.0)
                let spans = (if not ($has_alias | is-empty) {
                  # put the first word of the expanded alias first in the span
                  $spans | skip 1 | prepend ($has_alias | get expansion | split words | get 0)
                } else { $spans })
                carapace $spans.0 nushell $spans | from json
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
                # `commandline --insert` inserts at the start on 0.79,
                # temporary workaround using --append instead
                cmd: `commandline --append (fzf --height=50% | str trim | do { let res = $in; if (["'", '"', " "] | any { $in in $res }) { $'`($res)`' } else { $res }})`
              }
            },
            {
              name: fzf_dir
              modifier: alt
              keycode: char_f
              mode: [emacs, vi_insert, vi_normal]
              event: {
                send: executehostcommand
                cmd: `commandline --append (fd --type d | fzf --height=50% | str trim | do { let res = $in; if (["'", '"', " "] | any { $in in $res }) { $'`($res)`' } else { $res }})`
              }
            },
          ]
        }

        ${nuAliasesStr}

        # direnv
        # taken from home-manager git master; TODO: remove once it lands on stable
        let-env config = ($env | default {} config).config
        let-env config = ($env.config | default {} hooks)
        let-env config = ($env.config | update hooks ($env.config.hooks | default [] pre_prompt))
        let-env config = ($env.config | update hooks.pre_prompt ($env.config.hooks.pre_prompt | append {
          code: "
            let direnv = (${pkgs.direnv}/bin/direnv export json | from json)
            let direnv = if ($direnv | length) == 1 { $direnv } else { {} }
            $direnv | load-env
            "
        }))

        # zoxide (generated with `zoxide init nushell`
        # since home-manager doesn't currently have automation for this)

        let-env config = ($env | default {} config).config
        let-env config = ($env.config | default {} hooks)
        let-env config = ($env.config | update hooks ($env.config.hooks | default {} env_change))
        let-env config = ($env.config | update hooks.env_change ($env.config.hooks.env_change | default [] PWD))
        let-env config = ($env.config | update hooks.env_change.PWD ($env.config.hooks.env_change.PWD | append {|_, dir|
          zoxide add -- $dir
        }))

        # Jump to a directory using only keywords.
        def-env __zoxide_z [...rest:string] {
          let arg0 = ($rest | append '~').0
          let path = if (($rest | length) <= 1) and ($arg0 == '-' or ($arg0 | path expand | path type) == dir) {
            $arg0
          } else {
            (zoxide query --exclude $env.PWD -- $rest | str trim -r -c "\n")
          }
          cd $path
        }

        # Jump to a directory using interactive search.
        def-env __zoxide_zi  [...rest:string] {
          cd $'(zoxide query -i -- $rest | str trim -r -c "\n")'
        }

        alias z = __zoxide_z
        alias zi = __zoxide_zi
      '';
    envFile.text = ''
      # starship

      let-env STARSHIP_SHELL = "nu"

      def create_left_prompt [] {
          starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
      }

      let-env PROMPT_COMMAND = { create_left_prompt }
      let-env PROMPT_COMMAND_RIGHT = ""

      # starship brings its own indicator char
      let-env PROMPT_INDICATOR_VI_INSERT = ""
      let-env PROMPT_INDICATOR_VI_NORMAL = ""
      let-env PROMPT_MULTILINE_INDICATOR = "| "
    '';
  };
in
{ inherit nushell fish; }
