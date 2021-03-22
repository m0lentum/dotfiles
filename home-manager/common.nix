{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  programs = {
    #
    # GIT
    #
    git = {
      enable = true;
      userName = "Mikael Myyrä";
      userEmail = "mikael.myyrae@gmail.com";
      ignores = [
        "*.nogit*"
        ".envrc"
        ".vscode"
        ".vim"
        "Session.vim"
      ];
      lfs.enable = true;
      extraConfig = {
        pull = { rebase = true; };
        fetch = { prune = true; };
        diff = { colorMoved = "zebra"; };
      };
    };
    #
    # FISH
    #
    fish = {
      enable = true;
      interactiveShellInit = ''
        if not set -q TMUX
          exec tmux
        end
      '';
      shellAbbrs = {
        ls = "lsd";
        l = "lsd -al";
        ll = "lsd -l";
        tree = "lsd --tree";
        ga = "git add";
        gc = "git commit -v";
        "gc!" = "git commit -v --amend";
        gl = "git pull";
        gf = "git fetch";
        gco = "git checkout";
        gd = "git diff";
        gsh = "git show";
        gst = "git status";
        gb = "git branch";
        gsta = "git stash";
        gstp = "git stash pop";
        glg = "git log --stat";
        glga = "git log --stat --graph --all";
        glo = "git log --oneline";
        gloa = "git log --oneline --graph --all";
        grh = "git reset HEAD";
        vis = "nvim -S Session.vim";
        docc = "docker-compose";
      };
    };
    #
    # STARSHIP
    #
    starship = {
      enable = true;
      settings = {
        prompt_order = [
          "username" "hostname" "directory"
          "git_branch" "git_state" "git_status"
          "package" "nodejs" "ruby"
          "rust" "python" "golang" "cmd_duration"
          "line_break"
          "jobs" "battery" "nix_shell" "character"
        ];
        cmd_duration.min_time = 1;
        directory.fish_style_pwd_dir_length = 1;
        git_status = {
          show_sync_count = true;
          modified = "*";
        };
        nix_shell = {
          symbol = "";
          impure_msg = "λ";
          pure_msg = "λλ";
        };
        package.disabled =  true;
      };
    };
    #
    # KITTY
    #
    kitty = {
      enable = true;
      font = {
        name = "JetBrains Mono Medium Nerd Font Complete";
        package = pkgs.jetbrains-mono;
      };
      settings = {
        font_size = 11;
        disable_ligatures = "cursor";
        # solarized dark colors
        foreground = "#839496";
        foreground_bold = "#eee8d5";
        cursor = "#839496";
        cursor_foreground = "#002b36";
        background = "#002b36";
        # dark backgrounds
        color0 = "#073642";
        color8 = "#002b36";
        # light backgrounds
        color7 = "#eee8d5";
        color15 = "#fdf6e3";
        # grays
        color10 = "#586e75";
        color11 = "#657b83";
        color12 = "#839496";
        color14 = "#93a1a1";
        # accents
        color1 = "#dc322f";
        color9 = "#cb4b16";
        color2 = "#859900";
        color3 = "#b58900";
        color4 = "#268bd2";
        color5 = "#d33682";
        color13 = "#6c71c4";
        color6 = "#2aa198";
        color16 = "#cb4b16";
        color17 = "#d33682";
        color18 = "#073642";
        color19 = "#586e75";
        color20 = "#839496";
        color21 = "#eee8d5";
      };
    };
    #
    # TMUX
    #
    tmux = {
      enable = true;
      shortcut = "t";
      terminal = "screen-256color";
      keyMode = "vi";
      escapeTime = 0;
      extraConfig = ''
        # navigate panes with alt-arrow
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Left select-pane -L
        bind -n M-Down select-pane -D

        # navigate tabs
        bind -n M-C-NPage next-window
        bind -n M-C-PPage previous-window

        # splits & tabs
        bind > split-window -h -c "#{pane_current_path}"
        bind v split-window -v -c "#{pane_current_path}"
        bind t new-window -c "#{pane_current_path}"
        bind w kill-window

        # vim-style copy-paste
        bind u copy-mode
        bind p paste-buffer
        bind -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        bind -T copy-mode-vi r send-keys -X rectangle-toggle
        # copy also to clipboard
        bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -sel clip -i"

        set -g mouse on
        set -g focus-events on

        # bells off
        set -g visual-activity off
        set -g visual-bell off
        set -g visual-silence off
        setw -g monitor-activity off
        set -g bell-action none

        # panes and borders
        set -g pane-border-style 'bg=colour0 fg=colour10'
        set -g pane-active-border-style 'bg=colour0 fg=colour10'
        set -g window-style 'bg=colour8 fg=colour242'
        set -g window-active-style 'bg=colour8 fg=colour12'

        # statusbar
        set -g status-position bottom
        set -g status-justify left
        set -g status-style 'bg=colour0 fg=colour2 dim'
        set -g status-left ""
        set -g status-right '#[fg=colour255,bg=colour0]%d.%m. #[fg=colour255,bg=colour0]%H:%M '
        set -g status-right-length 50
        set -g status-left-length 20

        setw -g window-status-current-style 'fg=colour233 bg=colour2 bold'
        setw -g window-status-current-format ' #I#[fg=colour233]:#[fg=colour233]#W#[fg=colour233]#F '

        setw -g window-status-style 'fg=colour255 bg=colour0'
        setw -g window-status-format ' #I#[fg=colour255]:#[fg=colour255]#W#[fg=colour255]#F '

        # messages
        set -g message-style 'fg=colour0 bg=colour6 bold'

        # only close tabs by closing every terminal
        unbind w
      '';
    };
    #
    # VIM
    #
    neovim = {
      enable = true;
      withNodeJs = true;
      vimAlias = true;
      #
      # non-plugin configs
      #
      extraConfig = ''
        nnoremap <SPACE> <Nop>
        let mapleader = " "
        let maplocalleader = " "

        set autoread
        set hidden
        nnoremap <silent><C-PageUp> :bp<cr>
        nnoremap <silent><C-PageDown> :bn<cr>
        nnoremap <silent><leader>w :bdelete<cr>

        set mouse=a
        set scrolloff=15
        set clipboard=unnamedplus
        " reload file if it's been changed on disk
        au FocusGained,BufEnter * :checktime
        nnoremap <Home> ^

        set nobackup
        set nowritebackup

        " relative line numbers, only in focused normal mode
        set number relativenumber
        augroup numbertoggle
          autocmd!
          autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
          autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
        augroup END

        set cursorline
        set cursorcolumn
        set conceallevel=0
      '';
      #
      # plugin configs
      #
      plugins = with pkgs.vimPlugins; [
        #
        # visuals
        #
        {
          # custom fork of the oceanic-material theme
          plugin = pkgs.vimUtils.buildVimPlugin {
            name = "oceanic-material";
            pname = "oceanic-material";
            src = ../nvim/oceanic-material;
          };
          config = ''
            set termguicolors
            let g:oceanic_material_allow_bold=1
            let g:oceanic_material_allow_italic=1
            let g:oceanic_material_allow_underline=1
            let g:oceanic_material_allow_undercurl=1
            color oceanic_material
          '';
        }
        {
          plugin = vim-airline;
          config = ''
            let g:airline#extensions#tabline#enabled = 1
            let g:airline_powerline_fonts = 1
          '';
        }
        {
          plugin = vim-airline-themes;
          config = ''
            let g:airline_theme='bubblegum'
          '';
        }
        {
          plugin = rainbow;
          config = ''
            let g:rainbow_active = 1
          '';
        }
        {
          plugin = vim-indent-guides;
          config = ''
            let g:indent_guides_enable_on_vim_startup = 1
            let g:indent_guides_auto_colors = 0
            set expandtab
            set ts=2 sw=2
            let g:indent_guides_guide_size = 2
          '';
        }
        vim-signify

        #
        # language utilities
        #
        {
          plugin = coc-nvim;
          config = ''
            " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
            " delays and poor user experience.
            set updatetime=100
            set signcolumn=yes
            " Don't pass messages to |ins-completion-menu|.
            set shortmess+=c
            " Use <c-space> to trigger completion.
            inoremap <silent><expr> <c-space> coc#refresh()
            " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
            " position. Coc only does snippet and additional edit on confirm.
            if exists('*complete_info')
              inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
            else
              imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
            endif

            " navigate diagnostics
            nmap <silent> gN <Plug>(coc-diagnostic-prev)
            nmap <silent> gn <Plug>(coc-diagnostic-next)

            " GoTo code navigation.
            nmap <silent> gd <Plug>(coc-definition)
            nmap <silent> gy <Plug>(coc-type-definition)
            nmap <silent> gi <Plug>(coc-implementation)
            nmap <silent> gr <Plug>(coc-references)


            function! s:show_documentation()
              if (index(['vim','help'], &filetype) >= 0)
                execute 'h '.expand('<cword>')
              else
                call CocAction('doHover')
              endif
            endfunction

            " Highlight the symbol and its references when holding the cursor.
            autocmd CursorHold * silent call CocActionAsync('highlight')

            nnoremap <silent> gh :call <SID>show_documentation()<CR>
            nmap <F2> <Plug>(coc-rename)
            nnoremap <silent> <leader>M :<C-u>CocFzfList diagnostics<cr>
            nnoremap <silent> <leader>m :<C-u>CocFzfList diagnostics --current-buf<cr>
            nnoremap <silent> <leader>p :<C-u>CocFzfList commands<cr>
            nnoremap <silent> <leader>P :<C-u>CocFzfList<cr>
            nnoremap <silent> <leader>, :<C-u>CocAction<cr>
          '';
        }

        coc-rust-analyzer
        rust-vim

        coc-tsserver
        coc-eslint
        coc-prettier
        yats-vim

        {
          plugin = vim-markdown;
          config = ''
            let g:vim_markdown_folding_disabled = 1
            let g:vim_markdown_fenced_languages = ['rust=rs']
            let g:vim_markdown_math = 1
            let g:vim_markdown_frontmatter = 1
          '';
        }
        coc-markdownlint

        vim-nix
        coc-json
        vim-elm-syntax

        coc-vimtex
        {
          plugin = vimtex;
          config = ''
            let g:tex_flavor = 'latex'
            let g:tex_conceal = 'abdmg'
            autocmd FileType tex,md set conceallevel=1
            " for some reason this is empty by default, copied from docs
            let g:vimtex_compiler_latexmk_engines = {
              \ '_'                : '-pdf',
              \ 'pdflatex'         : '-pdf',
              \ 'dvipdfex'         : '-pdfdvi',
              \ 'lualatex'         : '-lualatex',
              \ 'xelatex'          : '-xelatex',
              \ 'context (pdftex)' : '-pdf -pdflatex=texexec',
              \ 'context (luatex)' : '-pdf -pdflatex=context',
              \ 'context (xetex)'  : '-pdf -pdflatex=""texexec --xtx""',
              \}
            let g:vimtex_view_method='zathura'
          '';
        }
        {
          plugin = ultisnips;
          config = ''
            let g:UltiSnipsSnippetDirectories = [$HOME . '/.config/nvim/ultisnips']
            let g:UltiSnipsExpandTrigger = '<tab>'
            let g:UltiSnipsJumpForwardTrigger = '<tab>'
            let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
          '';
        }

        #
        # QOL
        #
        {
          plugin = fzf-vim;
          config = ''
            let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
            nnoremap <C-p> :GFiles<cr>
            let g:fzf_action = {
              \ 'ctrl-n': 'tab split',
              \ 'ctrl-v': 'split',
              \ 'ctrl-r': 'vsplit' }
          '';
        }
        {
          plugin = git-messenger-vim;
          config = ''
            nmap <silent> gm <Plug>(git-messenger)
          '';
        }
        {
          plugin = vim-sneak;
          config = ''
            let g:sneak#label = 1
            map m <Plug>Sneak_s
            map M <Plug>Sneak_S
          '';
        }
        coc-fzf
        vim-obsession
        vim-commentary
        vim-surround
        vim-tmux-focus-events
      ];
    };
    #
    # MISC
    #
    firefox = {
      enable = true;
      package = (pkgs.firefox.override { extraNativeMessagingHosts = [ pkgs.passff-host ];});
    };
    zathura.enable = true;
    z-lua.enable = true;
    fzf.enable = true;
    feh.enable = true;
    direnv.enable = true;
    home-manager.enable = true;
  };

  services = {
    lorri.enable = true;
    picom = {
      enable = true;
      shadow = false;
      fade = true;
      fadeDelta = 4;
      blur = true;
      inactiveOpacity = "0.90";
      opacityRule = [
        # Opaque at all times
        "100:class_g = 'Firefox'"
        "100:class_g = 'feh'"
        "100:class_g = 'Sxiv'"
        "100:class_g = 'Zathura'"
        "100:class_g = 'vlc'"
        "100:class_g = 'obs'"
        "100:class_g = 'Wine'"
        "100:class_g = 'Microsoft Teams - Preview'"
        "100:class_g = 'zoom'"
        # Slightly transparent even when focused
        "95:class_g = 'VSCodium' && focused"
        "95:class_g = 'discord' && focused"
        "95:class_g = 'Spotify' && focused"
        "95:class_g = 'kitty' && focused"
      ];
      blurExclude = [
        # teams screenshare overlay
        "name *= 'rect-overlay'"
      ];
      # fixes flickering problems with glx backend
      backend = "xrender";
    };
    unclutter.enable = true;
    redshift = {
      enable = true;
      temperature = {
        day = 6500;
        night = 5000;
      };
      latitude = "62.24";
      longitude = "25.70";
    };
  };

  # extra stuff not in programs and/or config files managed manually
  home.packages = with pkgs; [
    # cli/dev utils
    lsd
    bat
    du-dust
    procs
    ytop
    fd
    hyperfine
    miniserve
    tokei
    ripgrep
    xclip
    vscodium
    rust-analyzer
    # general helpful stuff
    pass
    stretchly
    networkmanagerapplet
    # multimedia
    pulsemixer
    moreutils
    maim
    peek gifski dconf
    ffmpeg
    sxiv
    vlc
    xbindkeys
    xdotool
    pcmanfm
    notify-desktop
    zotero
  ];
  home.file = {
    "awesome" = {
      source = ../awesome;
      target = "./.config/awesome";
    };
    # trackball customization
    "xprofile" = {
      source = ../.xprofile;
      target = "./.xprofile";
    };
    "xbindkeysrc" = {
      source = ../.xbindkeysrc;
      target = "./.xbindkeysrc";
    };
    "coc-settings" = {
      source = ../nvim/coc-settings.json;
      target = ".config/nvim/coc-settings.json";
    };
    "ultisnips" = {
      source = ../nvim/snippets;
      target = ".config/nvim/ultisnips";
    };
  };

  xsession = {
    windowManager.awesome.enable = true;
    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata_Ice";
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "19.09";
}
