{ pkgs, listIgnores }:
{
  enable = true;
  vimAlias = true;
  #
  # non-plugin configs
  #
  extraConfig = ''
    nnoremap <space> <Nop>
    map <space> <leader>
    map <space> <localleader>

    set autoread
    set hidden
    " buffer controls replaced with bufferline-nvim
    " (in the plugins -> visual section of the config)
    " nnoremap <silent><C-PageUp> :bp<cr>
    " nnoremap <silent><C-PageDown> :bn<cr>
    nnoremap <silent><leader>w :bdelete<cr>

    " netrw off
    let loaded_netrwPlugin = 1

    set mouse=a
    set scrolloff=15
    set clipboard=unnamedplus
    " reload file if it's been changed on disk
    au FocusGained,BufEnter * :checktime
    nnoremap <Home> ^

    " paste from the non-volatile yank buffer
    noremap <leader>p "0p
    noremap <leader>P "0P

    set nobackup
    set nowritebackup

    set cursorline
    set cursorcolumn
    set conceallevel=1
    set concealcursor=
    set ignorecase
    set smartcase
  '';
  plugins = with pkgs.vimPlugins; [
    #
    # LSP and utilities
    #
    {
      # project-local settings with nlsp-settings
      plugin = nlsp-settings-nvim;
      config = ''
        lua << EOF
          require("nlspsettings").setup({
            config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
            local_settings_dir = ".nlsp-settings",
            local_settings_root_markers_fallback = { '.git' },
            append_default_schemas = true,
            loader = 'json'
          })
        EOF
      '';
    }
    {
      plugin = nvim-lspconfig;
      config = ''
        lua << EOF
        -- keybinds

        local opts = { noremap=true, silent=true }
        vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', 'gN', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', 'gn', vim.diagnostic.goto_next, opts)

        -- using telescope for anything that produces lists
        local tel = require('telescope.builtin')

        vim.keymap.set('n', '<C-p>', tel.find_files, opts)
        vim.keymap.set('n', '<leader>f', tel.live_grep, opts)
        vim.keymap.set('n', '<leader>.', tel.resume, opts)
        vim.keymap.set('n', 'gr', tel.lsp_references, opts)
        vim.keymap.set('n', 'gi', tel.lsp_implementations, opts)
        vim.keymap.set('n', '<leader>s', tel.lsp_document_symbols, opts)
        vim.keymap.set('n', '<leader>S', tel.lsp_workspace_symbols, opts)
        vim.keymap.set('n', 'gd', tel.lsp_definitions, opts)
        vim.keymap.set('n', '<leader>gd', tel.lsp_type_definitions, opts)
        vim.keymap.set('n', '<leader>M', tel.diagnostics, opts)
        vim.keymap.set('n', '<leader>m', function() tel.diagnostics({bufnr=0}) end, opts)

        local on_attach = function(client, bufnr)
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
          local bufopts = { noremap=true, silent=true, buffer=bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
          vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover, bufopts)
          vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', '<leader>,', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('v', ',', vim.lsp.buf.code_action, bufopts)

          -- override tsserver formatting with prettier from null-ls
          if client.name == 'tsserver' then
            client.server_capabilities.documentFormattingProvider = false
          end
        end

        -- format on save
        vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

        -- completion using cmp-nvim
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local enable = function(lsp_name, args)
          local args = args or {}
          args["on_attach"] = on_attach
          args["capabilities"] = capabilities
          require('lspconfig')[lsp_name].setup(args)
        end
              
        -- enable servers

        enable('rust_analyzer', {
          cmd = { "${pkgs.rust-analyzer}/bin/rust-analyzer" },
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = { command = "clippy" },
            }
          },
        })
        enable('wgsl_analyzer', {
          -- wgsl_analyzer is not currently on nixpkgs,
          -- so I install it in projects via nix flake
          cmd = { "wgsl_analyzer" },
        })
        enable('clangd', {
          cmd = { "${pkgs.clang-tools}/bin/clangd" },
        })
        enable('ts_ls', {
          cmd = {
            "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server",
            "--stdio",
          },
        })
        enable('jsonls', {
          cmd = {
            "${pkgs.nodePackages.vscode-json-languageserver}/bin/vscode-json-languageserver",
            "--stdio",
          },
        })
        enable('pyright', {
          cmd = { "${pkgs.pyright}/bin/pyright-langserver", "--stdio" },
        })
        enable('taplo', {
          cmd = { "${pkgs.taplo}/bin/taplo", "lsp", "stdio" },
        })
        enable('nushell', {})
        -- dart installed per-project because I almost never use it, no cmd override
        enable('dartls', {})

        -- nicer diagnostic icons

        local signs = {
            Error = " ",
            Warn = " ",
            Hint = " ",
            Info = " "
        }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
        end
        vim.diagnostic.config({
          -- prioritize errors and warnings in the sign column, otherwise everything looks like hints
          severity_sort = true,
          virtual_text = {
            prefix = "●",
            source = "if_many",
          },
        })
        EOF
      '';
    }
    # null-ls for formatters that don't come with lspconfig
    {
      plugin = null-ls-nvim;
      config = ''
        lua << EOF
        local null_ls = require('null-ls')
        null_ls.setup {
          debug = true,
          sources = {
            null_ls.builtins.formatting.isort,
            null_ls.builtins.formatting.black,
            null_ls.builtins.formatting.prettier,
          },
        }
        EOF
      '';
    }
    {
      # bindings for telescope defined in the LSP section above
      plugin = telescope-nvim;
      config = ''
        lua << EOF
        local actions = require('telescope.actions')
        require('telescope').setup {
          defaults = {
            mappings = {
              i = {
                ["<esc>"] = actions.close
              },
            },
            layout_config = {
              vertical = { width = 0.6, height = 0.9 },
            },
            layout_strategy = "vertical",
          },
          pickers = {
            find_files = {
              layout_strategy = "horizontal",
              -- remove leading ./, include gitignored and hidden files
              -- (except the stuff in listIgnores which is big and doesn't need to be seen)
              find_command = {
                "fd", "--type", "f", "--strip-cwd-prefix", "--no-ignore", "--hidden",
                ${pkgs.lib.strings.concatMapStrings (i: ''"--exclude","${i}",'') listIgnores}
              },
            },
          },
        }
        EOF
      '';
    }
    # completions with cmp-nvim
    cmp-nvim-lsp
    cmp-nvim-ultisnips
    cmp-omni
    cmp-cmdline
    {
      plugin = nvim-cmp;
      # from https://github.com/hrsh7th/nvim-cmp
      config = ''
        set completeopt=menu,menuone,noselect
        lua <<EOF
          require("cmp_nvim_ultisnips").setup {
            -- fixes snippets not working inside markdown math blocks
            filetype_source = "ultisnips_default",
          }

          local cmp = require('cmp')
          cmp.setup({
            snippet = {
              expand = function(args)
                vim.fn["UltiSnips#Anon"](args.body)
              end,
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-u>'] = cmp.mapping.scroll_docs(-8),
              ['<C-d>'] = cmp.mapping.scroll_docs(8),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }),
            }),
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'ultisnips' },
            }, {
              { name = 'buffer' },
            })
          })

          -- omnifunc completion for latex only,
          -- it causes problems in some languages with LSPs
          cmp.setup.filetype('tex', {
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'omni' },
              { name = 'ultisnips' },
            }, {
              { name = 'buffer' },
            })
          })

          cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
              { name = 'path' }
            }, {
              { name = 'cmdline' }
            })
          })
        EOF
      '';
    }

    #
    # non-LSP language utilities
    #

    {
      plugin = vim-markdown;
      config = ''
        let g:vim_markdown_folding_disabled = 1
        let g:vim_markdown_math = 1
        let g:vim_markdown_toml_frontmatter = 1
      '';
    }
    {
      plugin = vimtex;
      config = ''
        let g:tex_flavor = 'latex'
        let g:tex_conceal = 'abdmg'
        autocmd FileType tex,markdown set conceallevel=1
        " for some reason this is empty by default,
        " engines I use copied from docs
        let g:vimtex_compiler_latexmk_engines = {
          \ '_'                : '-pdf',
          \ 'xelatex'          : '-xelatex -shell-escape',
          \}
        let g:vimtex_view_method='zathura'
      '';
    }

    #
    # visuals
    #
    {
      plugin = pkgs.vimUtils.buildVimPlugin {
        name = "nightfly";
        pname = "nightfly";
        src = pkgs.fetchFromGitHub {
          owner = "bluz71";
          repo = "vim-nightfly-colors";
          rev = "547a94326e7fca9288b323edfa0599407b516e55";
          hash = "sha256-DKfrkggXURC/5RObBR9Ps3QsFpG0yimBAkJYW8CrdPU=";
        };
        # swap colors around for more green
        preInstall = ''
          substituteInPlace ./lua/nightfly/init.lua \
            --replace 'highlight(0, "NightflyGreen"' '__TMP__' \
            --replace 'highlight(0, "NightflyBlue"' 'highlight(0, "NightflyGreen"' \
            --replace '__TMP__' 'highlight(0, "NightflyBlue"' \
        '';
      };
      config = ''
        set termguicolors
        lua << EOF
        -- overrides
        local custom_highlight = vim.api.nvim_create_augroup("CustomHighlight", {})
        vim.api.nvim_create_autocmd("ColorScheme", {
          pattern = "nightfly",
          callback = function()
            vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { link = "DiagnosticError" })
            vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { link = "DiagnosticWarn" })
            vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { link = "DiagnosticInfo" })
            vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { link = "DiagnosticHint" })
          end,
          group = custom_highlight,
        })
        EOF
        let g:nightflyCursorColor=1
        colorscheme nightfly

        highlight DiffText guibg=#14332c
        highlight DiffAdd guibg=#1d354c
      '';
    }
    {
      plugin = indent-blankline-nvim;
      config = ''
        lua << EOF
        require("ibl").setup {
          indent = {
            highlight = {
              "NightflySlateBlue",
              "NightflyRegalBlue",
            }
          },
          scope = {
            highlight = { "NightflyMalibu" },
            show_start = false,
            show_end = false,
          },
        }
        EOF
      '';
    }
    {
      plugin = nvim-web-devicons;
      config = ''
        lua require("nvim-web-devicons").setup()
      '';
    }
    {
      plugin = gitsigns-nvim;
      config = ''
        " signcolumn flickers when no git signs if this isn't set
        set signcolumn=yes
        lua require("gitsigns").setup()
      '';
    }
    {
      plugin = feline-nvim;
      config = ''
        lua require("feline").setup()
      '';
    }
    {
      plugin = bufferline-nvim;
      config = ''
        lua << EOF
        require("bufferline").setup {
          options = {
            show_buffer_close_icons = false,
            diagnostics = "nvim_lsp",
            separator_style = "slant",
            right_mouse_command = nil,
            middle_mouse_command = "bdelete %d",
          }
        }
        EOF
        nnoremap <silent><C-PageDown> :BufferLineCycleNext<CR>
        nnoremap <silent><C-PageUp> :BufferLineCyclePrev<CR>
        nnoremap <silent><leader><C-PageDown> :BufferLineMoveNext<CR>
        nnoremap <silent><leader><C-PageUp> :BufferLineMovePrev<CR>
      '';
    }
    {
      plugin = pkgs.vimUtils.buildVimPlugin {
        name = "git-conflict.nvim";
        pname = "git-conflict.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "akinsho";
          repo = "git-conflict.nvim";
          rev = "v1.1.2";
          sha256 = "0axijf03qq48lgx6gfya92d5izr6bj4vhz2f41z767i3c8vcqimm";
        };
      };
      config = ''
        lua require("git-conflict").setup()
      '';
    }

    # tree-sitter based highlighting

    {
      plugin = nvim-treesitter.withPlugins (p: [
        p.tree-sitter-nix
        p.tree-sitter-rust
        p.tree-sitter-c
        p.tree-sitter-cpp
        p.tree-sitter-typescript
        p.tree-sitter-javascript
        p.tree-sitter-tsx
        p.tree-sitter-elm
        p.tree-sitter-haskell
        p.tree-sitter-python
        p.tree-sitter-markdown
        p.tree-sitter-markdown-inline
        p.tree-sitter-html
        p.tree-sitter-scss
        p.tree-sitter-css
        p.tree-sitter-make
        p.tree-sitter-bash
        p.tree-sitter-lua
        p.tree-sitter-latex
        p.tree-sitter-bibtex
        p.tree-sitter-toml
        p.tree-sitter-yaml
        p.tree-sitter-json
        p.tree-sitter-dockerfile
        p.tree-sitter-hcl
        p.tree-sitter-dart
        p.tree-sitter-nu
      ]);
      config = ''
        lua << EOF
        require'nvim-treesitter.configs'.setup {
          highlight = {
            enable = true,
            -- wgsl tree-sitter module is outdated, use highlight from wgsl-vim instead
            disable = { "wgsl" },
            additional_vim_regex_highlighting = { "wgsl" },
          },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "<leader>v",
              -- I don't tend to use search while selecting so this seems convenient
              node_incremental = "n",
              scope_incremental = "<leader>n",
              node_decremental = "N",
            },
          },
        }
        EOF
      '';
    }
    wgsl-vim
    {
      plugin = pkgs.fetchFromGitLab {
        owner = "HiPhish";
        repo = "rainbow-delimiters.nvim";
        rev = "862e0f5e867e1a4c93e3efe73d4c71b7b6d3fec8";
        hash = "sha256-5N/Lhuje8Eob3of+XVPSZxXRdQbCW/IVa2xvZh+Cq+g=";
      };
    }

    #
    # QOL / editing utilities
    #

    {
      plugin = ultisnips;
      config = ''
        let g:UltiSnipsSnippetDirectories = [$HOME . '/.config/nvim/ultisnips']
        let g:UltiSnipsExpandTrigger = '<tab>'
        let g:UltiSnipsJumpForwardTrigger = '<tab>'
        let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
      '';
    }
    {
      plugin = git-messenger-vim;
      config = ''
        nmap <silent> gm <Plug>(git-messenger)
      '';
    }
    {
      plugin = hop-nvim;
      config = ''
        lua << EOF
        local hop = require('hop')
        hop.setup {
          -- colemak-friendly keys
          keys = "tsradneiohpfwqgluyjkbcxzvm,"
        }
        local opts = { noremap=true, silent=true }
        vim.keymap.set("", 'm', hop.hint_char1, opts)
        vim.keymap.set("", 'L', hop.hint_lines, opts)
        vim.keymap.set("", 'M', hop.hint_words, opts)
        EOF
      '';
    }
    {
      plugin = vim-move;
      config = ''
        let g:move_map_keys = 0
        vmap <C-Up> <Plug>MoveBlockUp
        vmap <C-Down> <Plug>MoveBlockDown
        nmap <C-Up> <Plug>MoveLineUp
        nmap <C-Down> <Plug>MoveLineDown
        vmap <C-Left> <Plug>MoveBlockLeft
        vmap <C-Right> <Plug>MoveBlockRight
      '';
    }
    {
      plugin = mini-animate;
      config = ''
        lua require("mini.animate").setup()
      '';
    }
    {
      # sessions fully automatically
      plugin = auto-session;
      config = ''
        lua require("auto-session").setup()
      '';
    }
    vim-commentary
    {
      plugin = nvim-surround;
      config = ''
        lua require("nvim-surround").setup()
      '';
    }
    vim-sleuth # autodetect tab settings
  ];
}
